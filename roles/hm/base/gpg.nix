{ config, pkgs, secrets, ... }:

let
  template = pkgs.writeText "gpg-export.tex" ''
    \documentclass{article}

    \usepackage[a4paper]{geometry}
    \usepackage{caption,subcaption}
    \usepackage{listings}
    \usepackage{float}
    \usepackage{graphicx}
    \usepackage{pgffor}

    \begin{document}

    \centering
    \begin{figure}
    \foreach \i in {a, ..., d} {%
        \centering
        \begin{subfigure}[p]{0.45\textwidth}
            \includegraphics[width=\linewidth]{IMGa\i.png}
            \caption{ }\label{fig:subfig\i}
        \end{subfigure}\quad
    }
    \end{figure}

    To recover run the following command

    \begin{verbatim}
    for f in IMG*.png; do zbarimg --raw $f | head -c -1 > $f.out ; done
    cat *.out | base64 -d | paperkey --pubring public.key.gpg | gpg --import
    \end{verbatim}

    \pagebreak

    \lstinputlisting[]{public.key}

    \end{document}
  '';

  gpgExport = pkgs.writeScriptBin "gpg-export" ''
    #!${pkgs.stdenv.shell}

    key=$1
    if [[ -z "$key" ]]; then
        echo >&2 "Key ID should be passed as parameter. Aborting."; exit 1;
    fi

    workdir=$(pwd)

    dir=$(mktemp -d) && cd "$dir"
    trap 'rm -rf "$dir"' EXIT

    ${pkgs.gnupg}/bin/gpg --export-secret-key "$key" | ${pkgs.paperkey}/bin/paperkey --output-type raw | base64 > temp
    split temp -n 4 IMG
    for f in IMG*; do cat $f | ${pkgs.qrencode}/bin/qrencode -o $f.png; done

    ${pkgs.gnupg}/bin/gpg -armor --export "$key" > public.key

    ${pkgs.texlive.combined.scheme-small}/bin/pdflatex --shell-escape -jobname=gpg-export "${template}"

    cp gpg-export.pdf $workdir/
  '';
in

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    # List of keys exposed to the agent.
    # This should in the keygrip format. Find out using:
    # gpg --list-secret-keys --with-keygrip
    # Note that YubiKey keys are automatically loaded.
    sshKeys = secrets.ssh.keygrip;
  };

  programs.ssh = {
    enable = true;

    extraOptionOverrides = {
      Include = "config.local";
    };
  };

  home.packages = with pkgs; [
    gpgExport

    paperkey
    qrencode
    zbar
  ];
}


