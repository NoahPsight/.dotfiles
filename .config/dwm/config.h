/* appearance */
static unsigned int borderpx    = 0;  /* border pixel of windows */
static unsigned int gappx       = 0;  /* gaps between windows */
static unsigned int snap        = 16; /* snap pixel */
static int user_bh              = 0;  /* 0 means that dwm will calculate bar height */
static int vertpad              = 0;  /* vertical padding of bar */
static int sidepad              = 0;  /* horizontal padding of bar */
static int lrpadding            = 0;  /* left and right padding for text */

static const int showbar        = 1;  /* 0 means no bar */
static const int topbar         = 1;  /* 0 means bottom bar */
static const int viewonrulestag = 1;  /* 1 means when open applications view will move to tags defined in rules */
static const int colorfultag    = 1;  /* 0 means use SchemeSel for selected non vacant tag */
static int bordercolors         = 0;  /* 1 means clients will use the border color in rules */ 

static char font[]              = { "Hack:size=14:antialias=true:autohint=true" };
static char icons[]             = { "SymbolsNerdFont:size=16:antialias=true:autohint=true" };
static const char *fonts[]      = { font, icons };

static char bgd[]               = "#000000";  /* Background  */
static char fgd[]               = "#ffffff";  /* Foreground */
static char col0[]              = "#000000";  /* Black */ 
static char col1[]              = "#cc0403";  /* Red */ 
static char col2[]              = "#19cb00";  /* Green */ 
static char col3[]              = "#cecb00";  /* Yellow */ 
static char col4[]              = "#001cd1";  /* Blue */ 
static char col5[]              = "#cb1ed1";  /* Magenta */ 
static char col6[]              = "#0dcdcd";  /* Cyan */ 
static char col7[]              = "#e5e5e5";  /* White */ 
static char col8[]              = "#4d4d4d";  /* Bright Black */ 
static char col9[]              = "#3e0605";  /* Bright Red */ 
static char col10[]             = "#23fd00";  /* Bright Green */ 
static char col11[]             = "#fffd00";  /* Bright Yellow */ 
static char col12[]             = "#0026ff";  /* Bright Blue */ 
static char col13[]             = "#fd28ff";  /* Bright Magenta */ 
static char col14[]             = "#14ffff";  /* Bright Cyan */ 
static char col15[]             = "#ffffff";  /* Bright White */ 

static char *termcolor[] = { col0, col1, col2, col3, col4, col5, col6, col7,
                             col8, col9, col10, col11, col12, col13, col14, col15, bgd, fgd };

static char *colors[][3] = {
       /*                     fg        bg       border   */
       [SchemeNorm]       = { col8,     bgd,     bgd  },
       [SchemeSel]        = { col15,    bgd,     col9 },
       [SchemeTitle]      = { col15,    bgd,     bgd  },
       [SchemeTag]        = { col8,     bgd,     bgd  },
       [SchemeTag1]       = { col9,     bgd,     bgd  },
       [SchemeTag2]       = { col10,    bgd,     bgd  },
       [SchemeTag3]       = { col11,    bgd,     bgd  },
       [SchemeTag4]       = { col12,    bgd,     bgd  },
       [SchemeTag5]       = { col13,    bgd,     bgd  },
       [SchemeLayout]     = { col14,    bgd,     bgd  },
};

/* tagging */
static const char *tags[] = { "󰖟", "󰆍", "󰉋", "", "" };

static const int tagschemes[] = {
    SchemeTag1, SchemeTag2, SchemeTag3, SchemeTag4, SchemeTag5 };

static unsigned int ulinepad      = 3;    /* horizontal padding between the underline and tag */
static unsigned int ulinestroke   = 3;    /* thickness / height of the underline */
static unsigned int ulinevoffset  = 0;    /* how far above the bottom of the bar the line should appear */
static const int ulineall         = 0;    /

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Kitty",    NULL,       NULL,       0 << 0,       0,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Discord",  NULL,       NULL,       2 << 2,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

static const char *roficmd[] = { "rofi", "-show", "run", NULL };
static const char *termcmd[]  = { "kitty", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = roficmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

