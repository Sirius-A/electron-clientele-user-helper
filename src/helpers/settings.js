import settings from "electron-settings";
export default function (name, options) {

    settings.defaults({
        groupManagerRootPath: 'C:/Temp/',
        userDetailsExportPath: "C:/Users/Z002MKUM/Desktop/"
    });

}
