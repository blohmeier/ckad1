KEY:
ctrl-b + = prepended to all below UON
<""> = manual entry (no key binding)

WINDOWS
c create
, rename
p n previous/next
w list

PANES: divides a window (does NOT create new windows!) 
% vert
: <"split-window"> horiz
(no prepending!) ctrl-d = shuts pane; closing last pane closes window
arrow prev/next

SESSIONS: tmux new -s <session name> (is just like starting new tmux; then can run commands ...)
sudo apt-get install htop
htop
d exits the new session, but leaves htop running. check with ps aux | grep htop. could even log out ("logout") of the ssh session without killing htop -- can ssh back in and find it with ...)
tmux list-sessions
(then reattach with ...)
tmux attach -t <session name>

SOURCES
https://blog.codonomics.com/2019/09/essential-tmux-for-ckad-or-cka-exam.html
https://www.youtube.com/watch?v=BHhA_ZKjyxo
