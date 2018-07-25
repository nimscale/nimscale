set -ex

mkdir -p $HOME/nim/code/
mkdir -p $HOME/nim/done/
cd $HOME/nim

function reset {
    rm -rf $HOME/nim/done/
    rm -rf $HOME/nim/Nim/
    rm -rf $HOME/nim/code/
    rm -rf $HOME/nim/bin/
    mkdir -p $HOME/nim/code/
    rm -rf ~/.nimble/
}

function nim_compile {
    if [ -e $HOME/nim/done/nimscale_compile_done ] ; then
        echo "NO NEED TO COMPILE"
    else
        cd $HOME/nim/code
        if [ -d "$HOME/nim/code/Nim" ]; then
            cd Nim
            git pull
            #git checkout tags/v0.16.0
        else
            git clone https://github.com/nim-lang/Nim.git
            cd Nim
            #git checkout tags/v0.16.0            
        fi
        if [ -d "$HOME/nim/code/Nim/csources" ]; then
            cd csources
            git pull
            #git checkout tags/v0.16.0             
        else
            git clone --depth 1 https://github.com/nim-lang/csources.git
            cd csources
            #git checkout tags/v0.16.0     
        fi

        #are now in csources
        sh build.sh
        cd $HOME/nim/code/Nim
        bin/nim c koch
        ./koch boot -d:release
        ./koch nimble   
        ./koch tools     

        cd $HOME/nim

        mkdir -p $HOME/nim/bin
        cp $HOME/nim/code/Nim/bin/* $HOME/nim/bin
        export PATH=$HOME/nim/bin:$PATH



        # ./koch web
        #sh build_tools.sh
        # rm -f /usr/bin/nim*
        # rm -f /usr/local/bin/nim*
        # rm -rf /usr/local/lib/nim*
        # rm -rf /usr/lib/nim*
        # rm -f /usr/bin/koch*
        # rm -f /usr/local/bin/koch*

        # ln -s ~/nim/Nim/lib/ /usr/local/lib/nim
        # ln -s ~/nim/Nim/bin/nim /usr/local/bin/nim

        #nim e install_nimble.nims

        # ln -s ~/nim/Nim/bin/nimble /usr/local/bin/nimble
        # ln -s ~/nim/Nim/bin/nimgrep /usr/local/bin/nimgrep
        # ln -s ~/nim/Nim/bin/nimsuggest /usr/local/bin/nimsuggest
        # ln -s ~/nim/Nim/koch /usr/local/bin/koch
        # ln -s ~/nim/Nim/tools/nimweb /usr/local/bin/nimweb

        #DONT USE KOCH, doesn't work on osx for geninstall, which creates installer
        # ./koch geninstall
        # sh install.sh install
        rm -f $HOME/nim/lib
        ln -s ~/nim/code/Nim/lib $HOME/nim/lib
        touch $HOME/nim/done/nimscale_compile_done
        cd $HOME/nim
    fi
}

function setenv {
    export PATH=$HOME/.nimble/bin:$HOME/nim/bin:$PATH
    export NIM_LIB_PREFIX=$HOME/nim
    # cp ~/.bash_profile ~/.bash_profile2; cat ~/.bash_profile2 | grep -v '/.nimble' > ~/.bash_profile
    if [ -e ~/.bash_profile ] ; then
        echo ".bash profile exists"  
    else
        touch ~/.bash_profile
    fi
    sed -i.bak '/.nimble/d' ~/.bash_profile
    echo 'export PATH=$HOME/.nimble/bin:$HOME/nim/bin:$PATH' >> $HOME/.bash_profile
}

function install_deps {
    if [ -e $HOME/nim/done/nimscale_deps_done ] ; then
        echo "NO NEED TO INSTALL DEPS"
    else
        cd $HOME/nim
        
        nimble install libsodium -y
        nimble install redis -y
        nimble install libcurl -y
        nimble install fnmatch -y
        nimble install jester -y        
        nimble install libnotify -y
        nimble install lmdb -y
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
        nimble install pudge -y
        nimble install isa -y
        nimble install nimlua -y
        nimble install pymod -y
        nimble install cligen -y
        nimble install nifty -y
        nimble install nwt -y
        nimble install nim-slimdown -y

        #NOT WORKING BUT SHOULD
        # nimble install jwt -y
        # nimble install c2nim -y
        # nimble install capnp -y
        # nimble install karax



        #NOT WORKING
        # nimble install nimstopwatch -y
        # nimble install orientdb  -y #http://orientdb.com/orientdb/
        # nimble install nim-routine -y
        # nimble install nim-fnmatch -y
        # nimble install 'https://github.com/singularperturbation/nim-leveldb' -y
        #nimble install msgpack4nim   -y
        touch $HOME/nim/done/nimscale_deps_done
    fi
}

function install_nimscale {
    if [ -e $HOME/nim/done/nimscale_done ] ; then
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
            ln -s ~/nim/nimscale/nimscale $HOME/nim/lib/nim/nimscale
        fi
        touch $HOME/nim/done/nimscale_done
    fi

}

function playenv {
    if [ -e $HOME/nim/done/playenv_done ] ; then
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
        touch $HOME/nim/done/playenv_done
    fi

}

############

# reset

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

#at end remove the files for done, because if we call this again I am sure goal is to redo it
rm -f $TMPDIR/nimscale_compile_done
rm -f $TMPDIR/nimscale_deps_done
rm -f $TMPDIR/nimscale_done

echo "Installation Done!"
