const imageLoadingState = {
  mounted() {
    this.setImageLoadingState(!this.el.complete);

    this.el.addEventListener("load", () => {
      this.setImageLoadingState(false);
    });
    this.el.addEventListener("error", () => {
      this.setImageLoadingState(false);
    });
  },

  setImageLoadingState(value) {
    const id = this.el.getAttribute("id");
    const skeleton = document.getElementById(`skeleton-${id}`);
    const placeholder = document.getElementById(`placeholder-${id}`);
    this.el.setAttribute("data-js-loading", value);
    skeleton?.setAttribute("data-js-image-loading", value);
    placeholder?.setAttribute("data-js-image-loading", value);
    if (!value) {
      this.pushEvent("imageLoadingState.loaded", {
        id,
      });
    }
  },
};

export default imageLoadingState;
