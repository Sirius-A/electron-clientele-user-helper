import settings from "electron-settings";

settings.defaults({
    "email":{
        "subject": "Access to clientele ITSM ePortal",
        "text": "Lorem ipsum dolor sit amet."
    },
    "findUser":{
        "exportFilePath": "C:/Temp/_UserData.xml"
    }
});

settings.applyDefaults();

export * from "electron-settings";
