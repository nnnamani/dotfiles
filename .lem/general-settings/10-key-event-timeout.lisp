;; キー入力イベントの入力タイムアウト時間が短すぎて僕にはM-xが入力できない。
;; 0.5秒くらいにする
(in-package :lem-ncurses)
(let ((resize-code (get-code "[resize]"))
      (abort-code (get-code "C-]"))
      (escape-code (get-code "escape")))
  (defun get-event ()
    (tagbody :start
      (return-from get-event
        (let ((code (charms/ll:getch)))
          (cond ((= code -1) (go :start))
                ((= code resize-code) :resize)
                ((= code abort-code) :abort)
                ((= code escape-code)
                 (charms/ll:timeout 500) ; <- これ
                 (let ((code (prog1 (charms/ll:getch)
                               (charms/ll:timeout -1))))
                   (cond ((= code -1)
                          (get-key-from-name "escape"))
                         ((= code #.(char-code #\[))
                          (case (charms/ll:getch)
                            (#.(char-code #\<)
                               ;;sgr(1006)
                               (uiop:symbol-call :lem-mouse-sgr1006 :parse-mouse-event))
                            (#.(char-code #\1)
                               (csi\[1))
                            (t (get-key-from-name "escape"))))
                         (t
                          (let ((key (get-key code)))
                            (make-key :meta t
                                      :sym (key-sym key)
                                      :ctrl (key-ctrl key)))))))
                (t
                 (get-key code))))))))