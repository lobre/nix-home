{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      LAB = "$HOME/Lab";
      VISUAL = "vim";
      EDITOR = "vim";
    };

    shellAliases = {
      "ll"     = "ls -lh";
      "llt"    = "ll -rt";
      "lla"    = "ll -a";
      ".."     = "cd ..";
      "..."    = "cd ../..";
      "extip"  = "wget http://ipinfo.io/ip -qO -";
      "dl"     = "cd $HOME/Downloads && llt";
      "doc"    = "cd $HOME/Documents";
      "copy"   = "xclip -selection clipboard";
      "server" = "\ssh docker@lobr.fr";
      "goroot" = "cd $GOROOT/src";
      "gopath" = "cd $GOPATH/src";
      "sshh"   = "sed -rn 's/^\s*Host\s+(.*)\s*/\1/ip' ~/.ssh/config";
      "rg"     = "rg --no-ignore-vcs --smart-case";

      # Docker aliases
      "dip"    = "docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'";
      "dex"    = "docker exec -it";
      "drun"   = "docker run -it --rm";
      "dup"    = "docker-compose up -d";
      "dps"    = "docker ps --format 'table {{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}'";
      "dcps"   = "docker-compose ps";
    };

    initExtra = ''
      # Load nix if not already loaded
      if [ -z $NIX_PROFILES ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # Use xterm terminal colors
      export TERM='xterm-256color'

      # Include unversioned files
      if [ -f $HOME/.bashrc.local ]; then
         . $HOME/.bashrc.local
      fi

      # Elapsed time of process
      function pstime() {
          if [[ -n $1 ]]; then
              ps -p $1 -o pid,cmd,etime,uid,gid
          fi
      }

      # Calculate inline
      function calc() {
          bc -l <<< "$@"
      }

      # Vpn
      function vpn() {
          sudo openvpn "$LAB/vpn/$@.ovpn"
      }

      # Regex
      function regex() {
          awk 'match($0, /'"$1"'/) { print substr($0, RSTART, RLENGTH) }'
      }

      # Block find
      function block() {
          awk "/$1/,/$2/"
      }

      # Lines
      function lines() {
          sed -n "$1,$2p"
      }

      # Parents ls
      function llp() {
          local file=$(pwd)
          if [[ -n $1 ]]; then
              file=$1
          fi
          until [ "$file" = "/" ] || [ "$file" = "." ]; do
              ls -lda $file
              file=`dirname $file`
          done
      }

      function printFlask() {
          if [[ -n $@ ]]; then
              echo "Entering $@..."
          else
              echo "Entering lab..."
          fi
          echo "             "
          echo "        o    "   
          echo "       o     "
          echo "     ___     "
          echo "     | |     "
          echo "     | |     "
          echo "    .' '.    "
          echo "   /  o  \   "
          echo "  :____o__:  "
          echo "  '._____.'  "
          echo "             "
      }

      # Lab function
      function lab() {
          if [ -n "$1" ]; then
              cd $LAB
              dir=$(find -L . -maxdepth 2 -type d -wholename "*$1*" -print | sort | head -n1)
              if [ -n "$dir" ]; then
                  cd $dir
                  printFlask $(basename $dir) && ls
              else
                  echo "Project $1 does not exist"
                  cd - &> /dev/null
              fi
          else
              cd $LAB
              printFlask && ls
          fi
      }

      function printGo() {
          echo "                                                    "
          echo "                    .,:cc:,.          .';;;'.       " 
          echo "                 ':oooooooool,    .;looooooool;.    " 
          echo "    .........  ,ooooo:,,;cooooc .looooc;,,:looooc   " 
          echo "............  loooo'   ........:oooo;       ,oooo;  "
          echo "      ...... ,oooo'   loooooooooooo:         oooo:  "
          echo "             ,oooo:  ....'oooooooool       .coooo.  "
          echo "              cooooo:,,,cooooc.,oooooc,',;looooc.   "
          echo "               .:oooooooool;.   .;loooooooooc,.     " 
          echo "                  .;clc:,.         .,cllc;.         " 
          echo "                                                    "
      }

      # Quickly browse to go project
      function golab() {
          if [ -n "$1" ]; then
              cd $GOPATH
              dir=$(find -L src -maxdepth 3 -type d -name "*$1*" -print -quit)
              if [ -n "$dir" ]; then
                  cd $dir
                  printGo && ls
              else
                  echo "Go project $1 does not exist"
                  cd - &> /dev/null
              fi
          else
              cd $GOPATH/src
              printGo && ls
          fi
      }

      # Tcpdump clean
      function httpdump() {
          export port=80
          if [[ -n $1 ]]; then
              export port=$1
          fi
          sudo -E stdbuf -oL -eL /usr/sbin/tcpdump -A -s 10240 "tcp port $port and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)" | egrep -a --line-buffered ".+(GET |HTTP\/|POST )|^[A-Za-z0-9-]+: " | perl -nle "BEGIN{$|=1} { s/.*?(GET |HTTP\/[0-9.]* |POST )/\n$port/g; print }"
      }

      # Total memory of process
      function psmem() {
          ps -C $1 -O rss | gawk '{ count ++; sum += $2 }; END {count --; print "Number of processes =",count; print "Memory usage per process =",sum/1024/count, "MB"; print "Total memory usage =", sum/1024, "MB" ;};' 2>/dev/null
      }

      # Certificate aliases
      function cert() { openssl s_client -showcerts -servername $1 -connect $1:443 < /dev/null 2>&1; }
      function certexpiration() { cert $1 | openssl x509 -dates -noout; }
      function certlist() { awk -v cmd='openssl x509 -noout -subject' ' /BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt; }
      function certfile() { openssl x509 -in $1 -text -noout; }

      # Usage
      # certgen maindomain.local
      # certgen maindomain.local DNS:othername.local
      # certgen maindomain.local DNS:othername.local,IP:127.0.0.1
      function certgen() {
          local san=""
          if [[ -n $2 ]]; then
              san=",$2"
          fi
          openssl req \
              -x509 \
              -newkey rsa:4096 \
              -sha256 \
              -days 3650 \
              -nodes \
              -keyout "$1.key" \
              -out "$1.crt" \
              -extensions san \
              -config <(echo "[req]"; echo distinguished_name=req; echo "[san]"; echo "subjectAltName=DNS:$1$san") \
              -subj "/CN=$1"
      }

      # Strip comments
      function nocomments() {
          local char=#
          if [[ -n $1 ]]; then
              char=$1
          fi
          sed "/^\s*$/d;/^$char/d"
      }

      # Strace write
      function stracewrite() {
          sudo strace -e trace=write -s1000 -f $@ 2>&1 \
          | grep --line-buffered -o '".\+[^"]"' \
          | grep --line-buffered -o '[^"]\+[^"]' \
          | while read -r line; do
            printf "%b" $line;
          done
      }
    '';
  };
}
