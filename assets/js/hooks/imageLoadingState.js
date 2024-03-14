const imageHooks = {
  mounted() {
    this.setLoading(true);

    this.el.addEventListener("load", () => {
      this.setLoading(false);
    });
    this.el.addEventListener("error", () => {
      this.setLoading(false);
    });
  },

  setLoading(value) {
    this.el.setAttribute("data-loading", value);
    if (!value) {
      this.pushEvent("imageLoadingState.loaded", {
        id: this.el.getAttribute("id"),
      });
    }
  },
};

export default imageHooks;
