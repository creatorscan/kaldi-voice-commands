# download the models and other relating files from http://kaldi-asr.org/downloads/build/2/sandbox/online/egs/fisher_english/s5 , which are built using the fisher_english recipe. To use the online-nnet2 models, the reader only needs to download two directories: exp/tri5a/graph and exp/nnet2_online/nnet_a_gpu_online. Use the following commands to download the archives and extract them:
false && {
wget http://kaldi-asr.org/downloads/build/5/trunk/egs/fisher_english/s5/exp/nnet2_online/nnet_a_gpu_online/archive.tar.gz -O nnet_a_gpu_online.tar.gz
wget http://kaldi-asr.org/downloads/build/2/sandbox/online/egs/fisher_english/s5/exp/tri5a/graph/archive.tar.gz -O graph.tar.gz
mkdir -p nnet_a_gpu_online graph
tar zxvf nnet_a_gpu_online.tar.gz -C nnet_a_gpu_online
tar zxvf graph.tar.gz -C graph

# Here the archives are extracted to the local directory. We need to modify pathnames in the config files, which we can do as follows:

for x in nnet_a_gpu_online/conf/*conf; do
      cp $x $x.orig
        sed s:/export/a09/dpovey/kaldi-clean/egs/fisher_english/s5/exp/nnet2_online/:$(pwd)/: < $x.orig > $x
    done

# Next, choose a single wav file to decode. The reader can download a sample file by typing

wget http://www.signalogic.com/melp/EngSamples/Orig/ENG_M.wav

#This is a 8kHz-sampled wav file that we found online (unfortunately it is UK English, so the accuracy is not very good). It can be decoded with the following command:
}
 /home/bmk/Documents/Research/kaldi/src/online2bin/online2-wav-nnet2-latgen-faster --do-endpointing=false \
     --online=false --print-args=false \
     --config=nnet_a_gpu_online/conf/online_nnet2_decoding.conf \
     --max-active=7000 --beam=15.0 --lattice-beam=6.0 \
     --acoustic-scale=0.1 --word-symbol-table=graph/words.txt \
     nnet_a_gpu_online/final.mdl graph/HCLG.fst "ark:echo utterance-id1 utterance-id1|" "scp:echo utterance-id1 $1|" \
     ark:/dev/null &> out
 grep "utterance-id1 " out | sed "s|\[noise\]||g;s|uh ||;s|utterance-id1||g"  > out.parsed

