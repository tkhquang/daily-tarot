// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import { getHooks } from "live_svelte";
import LocalStateStore from "./hooks/localStateStore";
import ImageLoadingState from "./hooks/imageLoadingState";
import DarkThemeToggle from "./hooks/darkThemeToggle";
import ScrollToTop from "./hooks/scrollToTop";
import WebConsole from "./hooks/webConsole";
import * as Components from "../svelte/**/*.svelte";

import { SocketOptions } from "phoenix_live_view";

let Hooks = {
  LocalStateStore,
  ImageLoadingState,
  DarkThemeToggle,
  ScrollToTop,
  WebConsole,
  ...getHooks(Components),
};

interface MySocketOptions extends SocketOptions {
  longPollFallbackMs: number;
}

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {
    _csrf_token: csrfToken,
    locale: Intl.NumberFormat().resolvedOptions().locale,
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
    timezone_offset: -(new Date().getTimezoneOffset() / 60),
    color_mode: window.__theme,
  },
  hooks: Hooks,
  dom: {
    // Guarantee that some attributes set on the client-side are kept intact:
    onBeforeElUpdated(from, to): any {
      for (const attr of from.attributes) {
        if (attr.name.startsWith("data-js-")) {
          to.setAttribute(attr.name, attr.value);
        }
      }
    },
  },
} as MySocketOptions);

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
