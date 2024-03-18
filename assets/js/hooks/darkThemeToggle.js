// JS Hook for dark/light theme toggle
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
};

export default darkThemeToggle;
