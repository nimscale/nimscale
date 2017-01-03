set -ex

mkdir -p $HOME/nim
cd $HOME/nim

function nim_compile {
    cd $HOME/nim
    if [ -d "$HOME/nim/Nim" ]; then
        cd Nim
        git pull
        git checkout tags/v0.15.2
    else
        git clone https://github.com/nim-lang/Nim.git
        cd Nim
        #git checkout -b master origin/master
        git checkout tags/v0.15.2            
    fi
    if [ -d "$HOME/nim/Nim/csources" ]; then
        cd csources
        git pull
        git checkout tags/v0.15.2             
    else
        git clone https://github.com/nim-lang/csources
        cd csources
        #git checkout -b master origin/master
        git checkout tags/v0.15.2     
    fi

    sh build.sh
    cd ..
    bin/nim c koch
    ./koch boot -d:release
    #./koch tools
    sh build_tools.sh
    ./koch web
    #./koch nimble
    
    rm -f /usr/bin/nim*
    rm -f /usr/local/bin/nim*
    rm -rf /usr/local/lib/nim*
    rm -rf /usr/lib/nim*
    
    ln -s ~/nim/Nim/lib/ /usr/local/lib/nim
    ln -s ~/nim/Nim/bin/nim /usr/local/bin/nim

    nim e install_nimble.nims

    ln -s ~/nim/Nim/bin/nimble /usr/local/bin/nimble
    ln -s ~/nim/Nim/bin/nimgrep /usr/local/bin/nimgrep
    ln -s ~/nim/Nim/bin/nimsuggest /usr/local/bin/nimsuggest
    ln -s ~/nim/Nim/koch /usr/local/bin/koch
    ln -s ~/nim/Nim/tools/nimweb /usr/local/bin/nimweb

    #DONT USE KOCH, doesn't work on osx for geninstall, which creates installer
    # ./koch geninstall
    # sh install.sh install


}

function setenv {
    export PATH=$HOME/.nimble/bin:$PATH
    # cp ~/.bash_profile ~/.bash_profile2; cat ~/.bash_profile2 | grep -v '/.nimble' > ~/.bash_profile
    sed -i.bak '/.nimble/d' ~/.bash_profile
    echo 'export PATH=$HOME/.nimble/bin:$PATH' >> $HOME/.bash_profile
}

function install_deps {
    cd $HOME/nim
    nimble install nimlua -y
    nimble install libsodium -y
    nimble install redis -y
    nimble install libcurl -y
    nimble install c2nim -y
    #nimble install capnp -y
    nimble install fnmatch -y
    nimble install hastyscribe  -y
    nimble install jester -y
    nimble install jwt -y
    nimble install libnotify -y
    nimble install jwt -y
    nimble install lmdb -y
    nimble install msgpack4nim   -y
    nimble install nimlz4 -y
    nimble install nimongo -y
    nimble install nimPDF -y
    nimble install nimsnappy -y
    nimble install nimyaml -y
    nimble install notifications  -y
    nimble install oauth -y
    nimble install rbtree -y
    nimble install reactor -y
    nimble install RingBuffer  -y
    nimble install shorturl  -y
    nimble install signals -y
    nimble install sophia -y
    nimble install sphinx  -y
    nimble install struct -y
    nimble install telebot -y
    nimble install tuples  -y
    nimble install uri2   -y
    nimble install websocket  -y
    nimble install yaml  -y
    nimble install zip  -y
    nimble install enet  -y #http://enet.bespin.org/Features.html
    nimble install teafiles  -y #https://github.com/unicredit/nim-teafiles
    nimble install rethinkdb  -y
    nimble install otp  -y
    nimble install nimrpc -y
    nimble install fileinput -y
    nimble install https://github.com/singularperturbation/nim-leveldb -y

    #NOT WORKING
    # nimble install nimstopwatch -y
    # nimble install orientdb  -y #http://orientdb.com/orientdb/
    # nimble install nim-routine -y
    # nimble install nim-fnmatch -y

}

function install_nimscale {
    if [ -e $TMPDIR/nimscale_done ] ; then
        echo "NO NEED TO INSTALL NIMSCALE"
    else
        cd $HOME/nim
        if [ -d "$HOME/nim/nimscale" ]; then
            echo "nimscale does exist"
            cd nimscale
            git pull
            cd ..
        else
            git clone git@github.com:nimscale/nimscale.git
            ln -s ~/nim/nimscale/nimscale /usr/local/lib/nim/nimscale
        fi
        touch $TMPDIR/nimscale_done
    fi

}

function playenv {
    if [ -e $TMPDIR/playenv_done ] ; then
        echo "NO NEED TO INSTALL PLAYENV"
    else
        cd $HOME/nim
        if [ -d "$HOME/nim/playenv" ]; then
            echo "playenv does exist"
            cd playenv
            git pull
            cd ..
        else
            git clone git@github.com:nimscale/playenv.git
        fi
        touch $TMPDIR/playenv_done
    fi

}

############

# rm -f $TMPDIR/nimscale_compile_done
# rm -f $TMPDIR/nimscale_deps_done
# rm -f $TMPDIR/nimscale_done


if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    # echo 'install brew'
    export LANG=C; export LC_ALL=C
    nim_compile

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "linux"
    nim_compile
fi

setenv
install_deps
install_nimscale
playenv
