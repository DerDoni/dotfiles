;; [[file:config.org::*Defaults][Defaults:1]]
(setq user-full-name "Vincenzo Pace"
      user-mail-address "vincenzo.pace@mailbox.org")

(setq-default
      delete-by-moving-to-trash t
      window-combination-resize t
      x-stretch-cursor t
      major-mode 'org-mode
      history-length 1000
      prescient-history-length 1000)

(setq undo-limit 800000000
      evil-want-fine-undo t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")
(display-time-mode 1)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))
;; Defaults:1 ends here

;; [[file:config.org::*Company][Company:1]]
(after! company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-quick-access t
        )
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less
;; Company:1 ends here

;; [[file:config.org::*Bookmarks][Bookmarks:1]]
(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks" "L" #'list-bookmarks
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))
;; Bookmarks:1 ends here

;; [[file:config.org::*Keybindings within ibuffer mode][Keybindings within ibuffer mode:1]]
(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)
;; Keybindings within ibuffer mode:1 ends here

;; [[file:config.org::*Configuring Dashboard][Configuring Dashboard:1]]
(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "\nKEYBINDINGS:\
\nFind file               (SPC .)     \
Open buffer list    (SPC b i)\
\nFind recent files       (SPC f r)   \
Open the eshell     (SPC e s)\
\nOpen dired file manager (SPC d d)   \
List of keybindings (SPC h b b)")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.doom./doom-emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 5)
                          (projects . 5)
                          (registers . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))))
;; Configuring Dashboard:1 ends here

;; [[file:config.org::*Dashboard in Emacsclient][Dashboard in Emacsclient:1]]
(setq doom-fallback-buffer-name "*dashboard*")
;; Dashboard in Emacsclient:1 ends here

;; [[file:config.org::*Theming][Theming:1]]
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Oxygen Mono" :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 15)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))


(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))


(setq display-line-numbers-type 'relative
      confirm-kill-emacs nil)

;;(use-package modus-themes
;;  :ensure
;;  :init
;;  ;; Add all your customizations prior to loading the themes
;;  (setq modus-themes-italic-constructs t
;;        modus-themes-completions '((matches . (extrabold))
;;                                  (selection . (semibold accented))
;;                                  (popup . (accented intense)))
;;        modus-themes-variable-pitch-headings t
;;        modus-themes-scale-headings t
;;        modus-themes-variable-pitch-ui t
;;        modus-themes-org-agenda
;;        '((header-block . (variable-pitch scale-title))
;;          (header-date . (grayscale bold-all)))
;;        modus-themes-org-blocks
;;        '(grayscale)
;;        modus-themes-mode-line
;;        '(borderless)
;;        modus-themes-region '(bg-only no-extend))
;;
;;  ;; Load the theme files before enabling a theme
;;  (modus-themes-load-themes)
;;  :config
;;  (modus-themes-load-vivendi)
;;  :bind ("<f5>" . modus-themes-toggle))
;; Theming:1 ends here

;; [[file:config.org::*General Settings][General Settings:1]]
(setq org-directory "~/org/")
(after! org
  (require 'org-bullets)
  (require 'org-habit)
  :config
  (setq org-startup-folded t
        org-preview-latex-directory (expand-file-name "ltximg/" org-directory)
        org-habit-show-habits t
        org-agenda-files '("~/org/todo.org" "~/org/habits.org" )
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-my-anki-file (expand-file-name "anki.org" org-directory)
        org-log-done 'time
        org-journal-dir "~/org/journal/"
        org-journal-date-format "%B %d, %Y (%A)"
        org-journal-file-format "%Y-%m-%d.org"
        org-hide-emphasis-markers t
        org-pomodoro-length 25
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 20
        org-pomodoro-manual-break t
        org-pomodoro-play-sounds nil ))
;; General Settings:1 ends here

;; [[file:config.org::*Org Capture][Org Capture:1]]
(use-package! anki-editor
  :commands (anki-editor-mode)
  :init
  (map! :leader
      :desc "Anki Push tree"
      "m a p" #'anki-editor-push-tree)
  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze-number after each capture.
  :config
  (setq anki-editor-create-decks t ;; Allow anki-editor to create a new deck if it doesn't exist
        anki-editor-org-tags-as-anki-tags t
        anki-editor-break-consecutive-braces-in-latex t)

  (defun anki-editor-cloze-region-auto-incr (&optional arg)
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))
  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))
  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1"
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))
  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))
  ;; Initialize
  (anki-editor-reset-cloze-number)
  )


;; Org-capture templates
(setq org-my-anki-file "~/org/anki.org")
(after! org
    (add-to-list 'org-capture-templates
    '("a" "Anki basic"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: Mega\n:END:\n** Front\n%?\n** Back\n"))
    (add-to-list 'org-capture-templates
             '("A" "Anki cloze"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: Mega\n:END:\n** Text\n%x\n** Extra\n"))
    (add-to-list 'org-capture-templates
                '("g" "Game Dev Notes"
                  entry
                  (file+headline "~/org/my_rpg.org" "Capture")
                   "* %?\nEntered on %U\n  %i\n  %a"))
    (add-to-list 'org-capture-templates
                '("r" "Reading List"
                  entry
                  (file+headline "~/org/reading_list.org" "Capture")
                   "* %?Title\nby Author \n\nEntered on %U\n  %i\n  %a \n ")))

;; Allow Emacs to access content from clipboard.
(setq select-enable-clipboard t
      select-enable-primary t)

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (if (equal "org-capture" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice org-capture-destroy
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "org-capture" (frame-parameter nil 'name))
      (delete-frame)))

(defun make-orgcapture-frame ()
    "Create a new frame and run org-capture."
    (interactive)
    (make-frame '((name . "org-capture") (window-system . x)))
    (select-frame-by-name "org-capture")
    (org-capture)
    ;;(delete-other-windows)
    )
;; Org Capture:1 ends here

;; [[file:config.org::*Org Roam][Org Roam:1]]
(use-package! org-roam
:config
 (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)

          ("r" "reference" plain "%?"
           :if-new
           (file+head "reference/${slug}.org" "#+title: ${title}\n- source :: \n- tags :: \n \n ")
           :immediate-finish t
           :unnarrowed t)

          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${slug}.org" "#+title: ${title}\n#+filetags: :article:\n- source :: \n- tags :: \n \n* Summary \n* Key ideas \n* Methods insights \n* Interesting Concepts and sources \n")
           :immediate-finish t
           :unnarrowed t)

          ("M" "meeting" plain "%?"
           :if-new
           (file+head "meetings/%<%Y%m%d%S>-${slug}.org" "Meeting of : %t\n#+filetags: :meeting:\n")
           :immediate-finish t
           :unnarrowed t)

          ("b" "book notes" plain
           "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)

          ("d" "default" plain
           "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t))))
;; Org Roam:1 ends here

;; [[file:config.org::*Org Download][Org Download:1]]
(use-package org-download
    :after org
    :defer nil
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "images")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y%m%d-%H%M%S_")
    (org-image-actual-width 300)
    (org-download-screenshot-method "/usr/bin/flameshot gui --raw > %s")
    :bind
    ("C-M-y" . org-download-screenshot)
    :config
    (require 'org-download))
;; Org Download:1 ends here

;; [[file:config.org::*Org Pomodoro Polybar][Org Pomodoro Polybar:1]]
(defun ruborcalor/org-pomodoro-time ()
  "Return the remaining pomodoro time"
  (if (org-pomodoro-active-p)
      (cl-case org-pomodoro-state
        (:pomodoro
           (format "Pomo: %d minutes - %s" (/ (org-pomodoro-remaining-seconds) 60) org-clock-heading))
        (:short-break
         (format "Short break time: %d minutes" (/ (org-pomodoro-remaining-seconds) 60)))
        (:long-break
         (format "Long break time: %d minutes" (/ (org-pomodoro-remaining-seconds) 60)))
        (:overtime
         (format "Overtime! %d minutes" (/ (org-pomodoro-remaining-seconds) 60))))
    "No active pomo"))
;; Org Pomodoro Polybar:1 ends here

;; [[file:config.org::*Org-auto-tangle][Org-auto-tangle:1]]
(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))
;; Org-auto-tangle:1 ends here

;; [[file:config.org::*Mathpix][Mathpix:1]]
(use-package! mathpix.el
  :commands (mathpix-screenshot)
  :init
  (map! "C-x m" #'mathpix-screenshot)
  :config
  (setq mathpix-screenshot-method "xfce4-screenshooter -r -o cat > %s"
        mathpix-app-id (with-temp-buffer (insert-file-contents "./secrets/mathpix-app-id") (buffer-string))
        mathpix-app-key (with-temp-buffer (insert-file-contents "./secrets/mathpix-app-key") (buffer-string))))
;; Mathpix:1 ends here

;; [[file:config.org::*File permissions and ownership][File permissions and ownership:1]]
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))
;; File permissions and ownership:1 ends here

;; [[file:config.org::*Keybindings Within Dired With Peep-Dired-Mode Enabled][Keybindings Within Dired With Peep-Dired-Mode Enabled:1]]
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Keybindings Within Dired With Peep-Dired-Mode Enabled:1 ends here

;; [[file:config.org::*Making deleted files go to trash can][Making deleted files go to trash can:1]]
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")
;; Making deleted files go to trash can:1 ends here

;; [[file:config.org::*EMOJIS][EMOJIS:1]]
(use-package emojify
  :hook (after-init . global-emojify-mode))
;; EMOJIS:1 ends here

;; [[file:config.org::*NEOTREE][NEOTREE:1]]
(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree" "d n" #'neotree-dir)
;; NEOTREE:1 ends here

;; [[file:config.org::*MODELINE][MODELINE:1]]
(set-face-attribute 'mode-line nil :font "Ubuntu Mono-13")
(setq doom-modeline-height 30     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
;; MODELINE:1 ends here
