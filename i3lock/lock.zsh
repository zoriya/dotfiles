lock()
{
	WALLPAPER=~/.wallpapers/$(ls ~/.wallpapers | sort -R | head -n 1)
	i3lock -F -i $WALLPAPER --clock
}
