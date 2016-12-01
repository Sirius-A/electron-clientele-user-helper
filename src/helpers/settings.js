import settings from "electron-settings";

settings.defaults({
    "email":{
        "subject": "Access to clientele ITSM ePortal",
        "text": "Lorem ipsum dolor sit amet."
    },
    "findUser":{
        "exportFilePath": "C:/Temp/_UserData.xml"
    },
    "RichClientExePath":"C:/Program Files (x86)/Mproof/Clientele ITSM 2010/Client/Clientele.Loader.exe"
});

settings.applyDefaults();

export * from "electron-settings";
