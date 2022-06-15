#ifndef BLOCKS_PATH
	#define BLOCKS_PATH
#endif

#define PATH(event)  BLOCKS_PATH event


static Block blocks[] = {
/*    Icon  Command                      Update Interval  Update Signal */
	{ "",   PATH("dunst.sh"),            120,             20 },
	{ "",   PATH("redshift.sh"),         120,             19 },
	{ "",   PATH("cpu.sh"),              120,             18 },
	{ "",   PATH("memory.sh"),           120,             17 },
	{ "",   PATH("volume.sh"),           5,               16 },
	{ "",   PATH("language.sh"),         1,               21 },
	{ "",   PATH("bluetooth.sh"),        120,             15 },
	{ "",   PATH("network.sh"),          20,              14 },
	{ "",   PATH("battery.sh"),          60,              13 },
	{ "",   PATH("date.sh"),             240,             12 },
	{ "",   PATH("time.sh"),             10,              11 },
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
