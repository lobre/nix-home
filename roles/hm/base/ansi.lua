local bright = {
    black   = 8,
    red     = 9,
    green   = 10,
    yellow  = 11,
    blue    = 12,
    magenta = 13,
    cyan    = 14
}

local lexers = vis.lexers
lexers.STYLE_DEFAULT = 'back:default,fore:white' --done
lexers.STYLE_NOTHING = ''
lexers.STYLE_CLASS = 'fore:white' --done (class name in java)
lexers.STYLE_COMMENT = 'fore:' .. bright.black .. ',italics' --done
lexers.STYLE_CONSTANT = 'fore:' .. bright.blue --done (nil in go)
lexers.STYLE_DEFINITION = 'fore:red,reverse'
lexers.STYLE_ERROR = 'fore:red,italics'
lexers.STYLE_FUNCTION = 'fore:white' --done (keywords such as new)
lexers.STYLE_KEYWORD = 'fore:green,bold' --done (all keywords such as if, var, func, import, package)
lexers.STYLE_LABEL = 'fore:white' --done (goto and other labels)
lexers.STYLE_NUMBER = 'fore:' .. bright.blue --done (number value in code)
lexers.STYLE_OPERATOR = 'fore:white' --done (:=, dot and parenthesis in go)
lexers.STYLE_REGEX = 'fore:green,reverse'
lexers.STYLE_STRING = 'fore:' .. bright.yellow --done
lexers.STYLE_PREPROCESSOR = 'fore:' .. bright.black.. ',bold' --done (not in go but decorators)
lexers.STYLE_TAG = 'fore:blue,reverse'
lexers.STYLE_TYPE = 'fore:blue' --done (type such as string or int)
lexers.STYLE_VARIABLE = 'fore:yellow,reverse'
lexers.STYLE_WHITESPACE = '' --done (all the empty spaces)
lexers.STYLE_EMBEDDED = 'fore:' .. bright.yellow --done (code in markdown)
lexers.STYLE_IDENTIFIER = 'fore:white' --done (all the rest)

lexers.STYLE_LINENUMBER = 'fore:'..bright.black --done
lexers.STYLE_LINENUMBER_CURSOR = lexers.STYLE_LINENUMBER --done
lexers.STYLE_CURSOR = 'reverse'
lexers.STYLE_CURSOR_PRIMARY = lexers.STYLE_CURSOR
lexers.STYLE_CURSOR_LINE = 'underlined'
lexers.STYLE_COLOR_COLUMN = 'back:black'
lexers.STYLE_SELECTION = 'back:' .. bright.blue
lexers.STYLE_DEFAULT = 'back:default,fore:white'
lexers.STYLE_STATUS = 'back:white,fore:black' --done
lexers.STYLE_STATUS_FOCUSED = lexers.STYLE_STATUS .. ',bold' --done
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT --done (vertical separator)
lexers.STYLE_INFO = 'fore:default,back:default,bold'
lexers.STYLE_EOF = ''
