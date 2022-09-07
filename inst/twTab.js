function opentab(tabsetid, tabid) {
    const tabs = document.querySelectorAll("." + tabsetid);
    const contents = document.querySelectorAll("." + tabsetid + "-content");
    // remove twTab-active and twTabContent-active classes and hide content
    tabs.forEach(tab => {
      tab.classList.remove("twTab-active");
      // set active tab
      if (tab.id == tabid) tab.classList.add("twTab-active");
    });
    contents.forEach(c => {
      c.classList.remove("twTabContent-active");
      c.style.display = "none";
      // show content tab
      if (c.id == tabid + "-content") {
        c.classList.add("twTabContent-active");
        c.style.display = "block";
        $(c).trigger("shown");
      };
    });
}
