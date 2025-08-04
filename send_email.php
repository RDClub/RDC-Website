<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // REPLACE THIS WITH YOUR EMAIL:
    $to = "rarediseaseclub44@gmail.com";
    
    // Get form data (no need to change these)
    $name = strip_tags(trim($_POST['name']));
    $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
    $subject = strip_tags(trim($_POST['subject']));
    $message = strip_tags(trim($_POST['message']));
    
    // Email headers (no need to change)
    $headers = "From: $name <$email>\r\n";
    $headers .= "Reply-To: $email\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
    
    // Email content (customize if needed)
    $email_content = "New Contact Form Submission\n\n";
    $email_content .= "Name: $name\n";
    $email_content .= "Email: $email\n";
    $email_content .= "Subject: $subject\n\n";
    $email_content .= "Message:\n$message\n";
    
    // Send email
    if (mail($to, "Website Contact: $subject", $email_content, $headers)) {
        // REPLACE THIS WITH YOUR THANK YOU PAGE:
        header("Location: https://yourwebsite.com/thank-you.html");
    } else {
        // REPLACE THIS WITH YOUR ERROR PAGE:
        header("Location: https://yourwebsite.com/error.html");
    }
}
?>
