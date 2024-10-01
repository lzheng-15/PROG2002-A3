// Back to Top button functionality
const backToTopButton = document.getElementById('back-to-top');

window.onscroll = function() {
    if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 100) {
        backToTopButton.style.display = "block"; // Show button after scrolling 100px
    } else {
        backToTopButton.style.display = "none"; // Hide button at the top
    }
};

backToTopButton.addEventListener('click', function() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth' // Smooth scroll to top
    });
});
