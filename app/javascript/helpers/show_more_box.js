export const showMoreBox = (cellTargets) => {
  cellTargets.forEach(descriptionCell => {
    const voteDescription = descriptionCell.querySelector('.container-description');
    const hoverText = descriptionCell.querySelector('.hover-text');

    descriptionCell.addEventListener('mouseover', () => {
      voteDescription.classList.remove("inactive");
      hoverText.classList.add("hover-text-active");
    })

    descriptionCell.addEventListener('mouseout', () => {
      voteDescription.classList.add("inactive");
      hoverText.classList.remove("hover-text-active");
    })
  });
}
