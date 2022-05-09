<details><summary>Exam link</summary>
https://kodekloud.com/topic/mock-exam-1-5/
</p></details>

<details><summary>vim config</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo "source <(kubectl completion bash)" >> $HOME/.bashrc && \
echo -e 'set et nu sts=2 sw=2 ts=2 ' >> ~/.vimrc
EXPLAINED
set expandtab #never see \t again in your file - expands tab keypresses to space
set number
set softtabstop #of whitespace cols a tab/backspace keypress is worth
set shiftwidth=2 #of whitespace cols a "lvl of indent" is worth
set tabstop=2 #of whitespace cols a tab counts for

```
</p>
</details>

### Check 1 ###
<details><summary>
Deploy a pod named nginx-448839 using the nginx:alpine image.
</summary>
<p>
  
```bash
k run nginx-448839 --image=nginx:alpine
```
</p>
</details>

### Check 2 ###
<details><summary>
Create a namespace named apx-z993845.
</summary>
<p>
  
```bash
k create ns apx-z993845
```
</p>
</details>
