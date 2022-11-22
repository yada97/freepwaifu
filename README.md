
# 𓁟freepwaifu

A bash script to spoof users on a paid public wifi network. Finds users connected with actual internet connection and
spoofs their mac addresses to give you internet.
![App Screenshot](https://i.imgur.com/CpAwt8O.png)


## Authors

- [@yadazoro](https://www.github.com/yadazoro)


## Installation

Fly alien spaceship with

```bash
  https://github.com/yadazora/freepwaifu
  ./freepwaifu.sh
```
## Running requirements
* [fzf](https://github.com/junegunn/fzf)
* [nmcli](https://github.com/ushiboy/nmcli)
* [macchanger](https://github.com/alobbs/macchanger)
* [awk](https://github.com/onetrueawk/awk)
* [iw](https://aur.archlinux.org/iw-git.git)
* N.b. Most of this tools are likely pre installed in your linux environment or
can be installed using your respective package manager apt/pacman/yum/dnf/snap etc

## Things to note
* adjust sleep timers to suit your speed - also affects accuracy, slower is more accurate
* when running watch the routing prompted 
    * if ping is going to the right gateway e.g 192.168.88.1/ or if no gateway --mac didn't ping succcessfully
* Files are stored in /tmp/freep directory - You can manually acquire scans from there
* You can adjust how fast pings occur by adjusting timeout and tries

## License

[MIT](https://choosealicense.com/licenses/mit/)


## Contributing

Contributions are always welcome!
--Get my first hand personal changes at
[My git server](https://git.yada.quest)


