
description "vRP_loteria"

dependency "vrp"

ui_page "nui/ui.html"

files {
	"nui/ui.html",
    "nui/background.jpg",
    "nui/img/bg.png",
    "nui/img/loteria.png",
   	"nui/ui.js",
   	"nui/gothicb.ttf",
   	"nui/signpainter.ttf",
   	"nui/bootstrap.min.js",
   	"nui/bootstrap.min.css",
	"nui/ui.css",
   	"nui/responsive.css",
}

client_scripts{ 
  "@vrp/lib/utils.lua",
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}
