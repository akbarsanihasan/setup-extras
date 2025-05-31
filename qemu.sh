#!/usr/bin/env bash

clear

QEMU_ARCH_PACKAGES=(
	qemu-full
	libvirt
	virt-manager
	virt-viewer
	dnsmasq
	bridge-utils
	dmidecode
	swtpm
	openbsd-netcat
	iptables-nft
	libguestfs
	virtiofsd
)

QEMU_DEB_PACKAGES=(
	qemu-kvm
	qemu-system
	qemu-utils
	python3
	python3-pip
	libvirt-clients
	libvirt-daemon-system
	bridge-utils
	virtinst
	libvirt-daemon
	virt-manager
)

if command -v pacman &>/dev/null; then
	if ! sudo pacman -Sy --noconfirm "${QEMU_ARCH_PACKAGES[@]}"; then
		echo -e "Qemu installation failed"
		exit 1
	fi
fi

if command -v apt-get &>/dev/null; then
	sudo apt-get install -y
	if ! sudo apt-get install -y "${QEMU_DEB_PACKAGES[@]}"; then
		echo -e "Qemu installation failed"
		exit 1
	fi
fi

echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm.conf
echo "options kvm_intel emulate_invalid_guest_state=0" | sudo tee -a /etc/modprobe.d/kvm.conf
echo "options kvm ignore_msrs=1 report_ignored_msrs=0" | sudo tee -a /etc/modprobe.d/kvm.conf

sudo sed -i -e 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' \
	-e 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

sudo usermod -aG libvirt "$USER"
sudo usermod -aG libvirt-qemu "$USER"
sudo usermod -aG kvm "$USER"
sudo usermod -aG input "$USER"
sudo usermod -aG disk "$USER"

dconf write /org/virt-manager/virt-manager/xmleditor-enabled true
dconf write /org/virt-manager/virt-manager/console/resize-guest 1
dconf write /org/virt-manager/virt-manager/console/scaling 1
dconf write /org/virt-manager/virt-manager/console/auto-redirect false
dconf write /org/virt-manager/virt-manager/system-tray true
dconf write /org/virt-manager/virt-manager/new-vm/firmware "'uefi'"

sudo systemctl enable --now libvirtd

if sudo virsh net-info default >/dev/null 2>&1; then
	echo -e
	echo "Network 'default' is already defined."

	if ! sudo virsh net-info default | grep -E "Active:\s+yes"; then
		echo "Network 'default' is not started. Starting it now..."
		sudo virsh net-start default || true
	fi

	if ! sudo virsh net-info default | grep -qE "Autostart:\s+yes"; then
		echo "Network 'default' is not set to autostart. Configuring it now..."
		sudo virsh net-autostart default || true
	fi
else
	echo "Network 'default' is not defined. Defining it now..."
	sudo virsh net-define --file ./default.xml
	sudo virsh net-start default || true
	sudo virsh net-autostart default || true
	echo -e "Network 'default' has been defined, started, and set to autostart.\n"
fi

echo -e
echo "Installed, might need reboot"
