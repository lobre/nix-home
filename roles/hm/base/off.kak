# Custom off theme

# for code
face global value         default
face global type          default
face global variable      default
face global module        default
face global function      default
face global string        default
face global keyword       default
face global operator      default
face global attribute     default
face global comment       bright-black+i
face global documentation default
face global meta          default
face global builtin       default

# for markup
face global title  default
face global header default
face global mono   default
face global block  default
face global link   default
face global bullet default
face global list   default

# builtin faces
face global Default            default
face global PrimarySelection   black,blue+fg
face global SecondarySelection black,bright-blue+fg
face global PrimaryCursor      black,white
face global SecondaryCursor    black,bright-blue+fg
face global PrimaryCursorEol   black,white
face global SecondaryCursorEol black,bright-blue+fg
face global LineNumbers        bright-black
face global LineNumbersWrapped bright-black
face global LineNumberCursor   white
face global MenuForeground     black,blue
face global MenuBackground     default,black+g
face global MenuInfo           default
face global Information        default+g
face global InlineInformation  default,black+g
face global Error              white,red
face global StatusLine         default
face global StatusLineMode     yellow+b
face global StatusLineInfo     bright-black
face global StatusLineValue    green
face global StatusCursor       black,white
face global Prompt             yellow
face global MatchingChar       +u
face global Whitespace         +fd
face global BufferPadding      bright-black

hook global ModeChange (push|pop):.*:insert %{
    set-face window PrimaryCursor black,yellow
    set-face window PrimaryCursorEol black,yellow
}

hook global ModeChange (push|pop):insert:.* %{
    unset-face window PrimaryCursor
    unset-face window PrimaryCursorEol
}

# kak-lsp
face global InlayHint              +d@type
face global InlayDiagnosticError   red
face global InlayDiagnosticWarning yellow
face global InlayDiagnosticInfo    blue
face global InlayDiagnosticHint    white
face global LineFlagError          red
face global LineFlagWarning        yellow
face global LineFlagInfo           blue
face global LineFlagHint           white
face global DiagnosticError        red+c # from default faces
face global DiagnosticWarning      yellow+c # from default faces
face global DiagnosticInfo         +c
face global DiagnosticHint         +u

# infobox
face global InfoDefault               Information
face global InfoBlock                 block
face global InfoBlockQuote            block
face global InfoBullet                bullet
face global InfoHeader                header
face global InfoLink                  link
face global InfoLinkMono              header
face global InfoMono                  mono
face global InfoRule                  comment
face global InfoDiagnosticError       InlayDiagnosticError
face global InfoDiagnosticHint        InlayDiagnosticHint
face global InfoDiagnosticInformation InlayDiagnosticInfo
face global InfoDiagnosticWarning     InlayDiagnosticWarning
