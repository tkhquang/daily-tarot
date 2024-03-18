// JS Hook for scroll to top of the page
const scrollToTop = {
  mounted() {
    // this.handleEvent("scrollToTop", () => this.scrollToTop());

    this.el.addEventListener("click", (e) => {
      this.scrollToTop();
    });
  },

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  },
};

export default scrollToTop;
