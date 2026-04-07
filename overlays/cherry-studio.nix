final: prev: {
  cherry-studio = prev.cherry-studio.override {
    electron_38 = final.electron_39;
  };
}
