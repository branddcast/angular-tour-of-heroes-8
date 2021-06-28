(window => {
    window.env = window.env || {};

    window["env"]["host"] = "${HOST}";
    window["env"]["api"] =  "${API}";
    window["env"]["user"] = "${USER}";
    window["env"]["username"] = "${USERNAME}";
    window["env"]["env"] = "${ENV}";
})(this)