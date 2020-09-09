const SendActions = {
    ready: "ready",
    loadNews: "loadNews"
};

class NativeCaller {
    constructor() {
        this.communicator =
            window.ReactNativeWebView ||
            window.native ||
            webkit.messageHandlers.native;

        // queues for downloading html
        this.queues = {};
    }

    postMessage(action, data) {
        const jsonString = JSON.stringify({
            action: action,
            data: data || {}
        });

        this.communicator.postMessage(jsonString);
    }
}

const nativeCaller = new NativeCaller(),
    baseUrl = "https://www.gosugamers.net/";

// Inject jQuery if not
function injectjQuery() {
    return new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.id = "my_injection";
        script.onload = () => resolve();
        script.onerror = () => reject();
        script.src = "https://code.jquery.com/jquery-3.3.1.min.js";

        document.head.appendChild(script);
    });
}


async function goGetLinks() {
    var code = document.getElementsByTagName('video')[0].src;
    if (typeof(code) == 'undefined') {
        console.log("undefined");
    }else{
        if(!code.includes(".mp4")){
             goGetPackedFunctionLinks();
        }else{
           goGetDirectLink();
        }
    }

}

async function goGetDirectLink() {
    const nativeCommunicator = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;

    var code = "oneLink" + document.getElementsByTagName('video')[0].src;
    nativeCommunicator.postMessage(code);
}


async function goGetPackedFunctionLinks() {
    var scriptCount = document.getElementsByTagName('script').length;
    var code;
    for (i = 0; i < scriptCount; i++) {
        if (document.getElementsByTagName('script')[i].innerText.includes("eval(function(p,a,c,k,e,d)")) {
            code = document.getElementsByTagName('script')[i].innerText;
            break;
        }
    }

    code = code.replace("eval", "'VideoEval' + '#>#>#>#' +");
    const nativeCommunicator = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;
    nativeCommunicator.postMessage(code);
}


async function unPack(code) {
    const nativeCommunicator = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;

    var data = code.substring(
        code.indexOf("[{"),
        code.indexOf("}]") + 2
    );

    nativeCommunicator.postMessage("Links" + data);
}