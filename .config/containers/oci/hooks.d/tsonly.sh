#!/bin/sh
set -ex
ipxtables() {
  iptables $@ && ip6tables $@
}
iptables -A OUTPUT -p icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT
ipxtables -A OUTPUT -o lo -j ACCEPT
ipxtables -A OUTPUT -o tailscale0 -j ACCEPT
# link local
# ipxtables -A OUTPUT -d '169.254.0.0/16' -j ACCEPT
# wireguard direct tunnelling
ipxtables -A OUTPUT -p udp --dport 41641 -j ACCEPT
# https
ipxtables -A OUTPUT -p tcp --dport 443 -j ACCEPT
# stun
ipxtables -A OUTPUT -p udp --dport 3478 -j ACCEPT
# mullvad
ipxtables -A OUTPUT -p udp --dport 51820 -j ACCEPT
# nat-pmp and upnp
ipxtables -A OUTPUT -p udp --dport 1900 -j DROP
ipxtables -A OUTPUT -p udp --dport 5351 -j DROP
# captive portal detection
ipxtables -A OUTPUT -p tcp --dport 80 -j DROP
# bittorrent local peer detection
ipxtables -A OUTPUT -p udp --dport 6771 -j DROP
ipxtables -A OUTPUT -p udp --sport 6771 -j DROP
# outbound dns
ipxtables -A OUTPUT -p tcp --dport 53 -j DROP
ipxtables -A OUTPUT -p udp --dport 53 -j DROP

ipxtables -A OUTPUT -j LOG
ipxtables -P OUTPUT DROP
