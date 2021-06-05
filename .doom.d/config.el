;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(map! :leader
      :desc "List bookmarks"
      "b L" #'list-bookmarks
      :leader
      :desc "Save current bookmarks to bookmark file"
      "b w" #'bookmark-save)

(setq user-full-name "Vincenzo Pace"
      user-mail-address "vincenzo.pace@mailbox.org"
      display-line-numbers-type t
      confirm-kill-emacs nil)


(setq doom-font (font-spec :family "Iosevka" :size 20))

(set-email-account! "Mailbox"
  '((mu4e-sent-folder       . "/mailbox/Sent Mail")
    (mu4e-drafts-folder     . "/mailbox/Drafts")
    (mu4e-trash-folder      . "/mailbox/Trash")
    (mu4e-refile-folder     . "/mailbox/All Mail")
    (smtpmail-smtp-user     . "vincenzo.pace@mailbox.org")
    (user-mail-address      . "vincenzo.pace@mailbox.org")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "---\nVincenzo Pace"))
  t)

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)


(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
  (require 'org-bullets)  ; Nicer bullets in org-mode
  (require 'org-habit)
;;  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;; Auto save org-files, so that we prevent the locking problem between computers
  (add-hook 'auto-save-hook 'org-save-all-org-buffers)
 '(org-clock-mode-line-total (quote today))
  :config
  ;; Default org-mode startup
  (setq org-startup-folded t
        org-preview-latex-directory (expand-file-name "ltximg/" org-directory))
  (setq org-directory "~/org/"
        org-habit-show-habits t
        org-agenda-files '("~/org/todo.org" "~/org/habits.org" "~/org/journal" "~/org/journal.org")
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-my-anki-file (expand-file-name "anki.org" org-directory)
        org-log-done 'time
        org-journal-dir "~/org/journal/"
        org-journal-date-format "%B %d, %Y (%A)"
        org-journal-file-format "%Y-%m-%d.org"
        org-hide-emphasis-markers t
        org-pomodoro-manual-break t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
       org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"
             "RESEARCH(r)"
             "NEXT(n)"
             "PROJ(p)"
             "WAIT(w)"
             "|"
             "DONE(d)"
             "CANCELLED(c)" ))))

(use-package! org-download
  :commands
  org-download-dnd
  org-download-yank
  org-download-screenshot
  org-download-dnd-base64
  :init
  (map! :map org-mode-map
        "s-Y" #'org-download-screenshot
        "s-y" #'org-download-yank)
  (pushnew! dnd-protocol-alist
            '("^\\(?:https?\\|ftp\\|file\\|nfs\\):" . org-download-dnd)
            '("^data:" . org-download-dnd-base64))
  (advice-add #'org-download-enable :override #'ignore)
  :config
  (defun +org/org-download-method (link)
    (let* ((filename
            (file-name-nondirectory
             (car (url-path-and-query
                   (url-generic-parse-url link)))))
           ;; Create folder name with current buffer name, and place in root dir
           (dirname (concat "./images/"
                            (replace-regexp-in-string " " "_"
                                                      (downcase (file-name-base buffer-file-name))))))
      (make-directory dirname t)
      (expand-file-name filename dirname)))
  :config
  ;; org-attach method
(setq-default org-attach-method 'mv
              org-attach-auto-tag "attach"
              org-attach-store-link-p 't)
(setq-default org-download-method 'directory
              org-download-image-dir "~/org/screenshots/"
              org-download-heading-lvl nil
              org-download-delete-image-after-download t
              ;;org-download-screenshot-method "flameshot gui --raw > %s"
              org-download-image-org-width 300
              org-download-annotate-function (lambda (link) "") ;; Don't annotate
              )
:config
  (defun +org/org-download-method (link)
    (let* ((filename
            (file-name-nondirectory
             (car (url-path-and-query
                   (url-generic-parse-url link)))))
           ;; Create folder name with current buffer name, and place in root dir
           (dirname (concat "./images/"
                            (replace-regexp-in-string " " "_"
                                                      (downcase (file-name-base buffer-file-name))))))
      (make-directory dirname t)
      (expand-file-name filename dirname)))
:config
(setq org-download-screenshot-method
        (cond (IS-MAC "screencapture -i %s")
              (IS-LINUX
               (cond ((executable-find "maim")  "maim -u -s %s")
                     ((executable-find "scrot") "scrot -s %s")))))
  (setq org-download-method '+org/org-download-method))

(use-package! mathpix.el
  :commands (mathpix-screenshot)
  :init
  (map! "C-x m" #'mathpix-screenshot)
  :config
  (setq ;;mathpix-screenshot-method "flameshot -p %s"
        mathpix-app-id (with-temp-buffer (insert-file-contents "./secrets/mathpix-app-id") (buffer-string))
        mathpix-app-key (with-temp-buffer (insert-file-contents "./secrets/mathpix-app-key") (buffer-string))))

(use-package! anki-editor
  :commands (anki-editor-mode)
  :init
  (map! :leader
      :desc "Anki Push tree"
      "a p" #'anki-editor-push-tree)
  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze-number after each capture.
  :config
  (setq anki-editor-create-decks t ;; Allow anki-editor to create a new deck if it doesn't exist
        anki-editor-org-tags-as-anki-tags t)

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
(setq org-my-anki-file "/home/vincenzo/org/anki.org")
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
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: Mega\n:END:\n** Text\n%x\n** Extra\n")))

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
    (counsel-org-capture)
    (delete-other-windows)
    )
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
