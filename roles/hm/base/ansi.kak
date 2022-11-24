# Custom ansi theme

# for code
face global value         bright-blue
face global type          blue
face global variable      bright-magenta
face global module        bright-black+b
face global function      blue
face global string        bright-yellow
face global keyword       green
face global operator      default
face global attribute     green
face global comment       bright-black+i
face global documentation comment
face global meta          bright-black+b
face global builtin       +b

# for markup
face global title  yellow+b
face global header white+b
face global mono   default+b
face global block  default+b
face global link   blue+u
face global bullet green
face global list   default

# builtin faces
face global Default            default
face global PrimarySelection   black,bright-blue+fg
face global SecondarySelection black,blue+fg
face global PrimaryCursor      +r
face global SecondaryCursor    +r
face global PrimaryCursorEol   black,white+fg
face global SecondaryCursorEol black,white+fg
face global LineNumbers        bright-black
face global LineNumbersWrapped bright-black+d
face global LineNumberCursor   white
face global MenuForeground     black,blue
face global MenuBackground     white,black
face global MenuInfo           default
face global Information        white
face global Error              black,red
face global StatusLine         white,black
face global StatusLineMode     yellow+b
face global StatusLineInfo     bright-black
face global StatusLineValue    green
face global StatusCursor       black,white
face global Prompt             yellow
face global MatchingChar       +u
face global Whitespace         +fd
face global BufferPadding      bright-black

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
