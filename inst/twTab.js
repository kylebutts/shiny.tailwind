document.querySelectorAll(".twTab").forEach(tab => tab.addEventListener("click", function() {
  const tabs = document.querySelectorAll(".twTab");
  const contents = document.querySelectorAll(".twTabContent");
  // remove twTab-active and twTabContent-active classes and hide content
  tabs.forEach(tab => tab.classList.remove("twTab-active"));
  contents.forEach(c => {
    c.classList.remove("twTabContent-active");
    c.style.display = "none";
  });
  // Show the contents and add highlighted classes
  document.getElementById(tab.id).classList.add("twTab-active");
  const cont = document.getElementById(tab.id + "-content");
  cont.classList.add("twTabContent-active");
  cont.style.display = "block";
  $(cont).trigger("shown");
}));
