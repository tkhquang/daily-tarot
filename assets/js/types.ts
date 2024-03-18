import { LiveSocket } from "phoenix_live_view";

declare global {
  interface Window {
    liveSocket: LiveSocket; //Phoenix LiveView
    userToken: string; //Phoenix Sockets
    /**
     * Theme Toggle
     * Added in:
     * lib/daily_tarot_web/components/layouts/root.html.heex
     */
    __theme: "light" | "dark";
    __setPreferredTheme: (mode: "light" | "dark") => void;
  }
}
