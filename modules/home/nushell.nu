module vprompt {
    # Complete escape sequence based on environment
    def complete-escape-by-env [
        arg: string # argument to send
    ] {
        let tmux: string = (if ($env.TMUX? | is-empty) { '''''' } else { $env.TMUX })
        let term: string = (if ($env.TERM? | is-empty) { '''''' } else { $env.TERM })
        if $tmux =~ "screen|tmux" {
            # tell tmux to pass the escape sequences through
            $"\ePtmux;\e\e]($arg)\a\e\\"
        } else if $term =~ "screen.*" {
            # GNU screen (screen, screen-256color, screen-256color-bce)
            $"\eP\e]($arg)\a\e\\"
        } else {
            $"\e]($arg)\e\\"
        }
    }
    def get-pwd-repr [] {
        "~" | path join (pwd | path relative-to $env.HOME)
    }
    def create_left_prompt [] {
        $"[(hostname)] (get-pwd-repr) "
    }
    # Output text prompt that vterm can use to track current directory
    export def left-prompt-track-cwd [] {
        $"(create_left_prompt)(complete-escape-by-env $'51;A(whoami)@(hostname):(pwd)')"
    }
}
use vprompt
$env.PROMPT_COMMAND = {|| vprompt left-prompt-track-cwd }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ":: "
$env.config = {
  keybindings: [
    {
      name: disable_ctrl_o
      modifier: control
      keycode: char_o
      mode: [emacs vi_insert vi_normal]
      event: null
    }
  ]
}
