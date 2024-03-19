// JS Hook for dark/light theme toggle
import { ViewHook } from "phoenix_live_view";

interface DarkThemeToggle extends Partial<Omit<ViewHook, "el">> {
  el?: HTMLButtonElement;
  toggleTheme: () => void;
}

const darkThemeToggle = {
  mounted() {
    this.handleEvent("darkThemeToggle", () => this.toggleTheme());
  },

  toggleTheme() {
    const isCurrentLight = window.__theme === "light";
    window.__setPreferredTheme(isCurrentLight ? "dark" : "light");
    this.pushEvent("darkThemeToggle.changed", {
      mode: isCurrentLight ? "dark" : "light",
    });
  },
} satisfies DarkThemeToggle;

export default darkThemeToggle;
