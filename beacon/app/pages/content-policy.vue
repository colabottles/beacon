<template>
  <div class="content-policy-page">
    <div class="container container-content py-16">
      <article class="prose">
        <h1>Content Policy</h1>
        
        <p class="lead">
          Beacon exists to support independent journalism and thoughtful writing. Our platform is built on principles of truth, dignity, and respect for all people.
        </p>

        <h2>Our Commitment</h2>
        <p>
          We believe in the power of free expression and independent journalism. We also believe that hate speech, harassment, and misinformation have no place in a healthy information ecosystem. This policy outlines what is and isn't allowed on Beacon.
        </p>

        <h2>What's Not Allowed</h2>

        <h3>Hate Speech and Discrimination</h3>
        <p>
          Content that promotes, encourages, or incites hatred, violence, or discrimination against individuals or groups based on:
        </p>
        <ul>
          <li>Race or ethnicity</li>
          <li>National origin</li>
          <li>Religion or religious affiliation</li>
          <li>Gender identity or expression</li>
          <li>Sexual orientation</li>
          <li>Disability or medical condition</li>
          <li>Age</li>
        </ul>
        <p>
          This includes nazi ideology, white supremacy, racism, antisemitism, islamophobia, and all other forms of bigotry.
        </p>

        <h3>Harassment and Abuse</h3>
        <p>
          Content that targets individuals or groups with:
        </p>
        <ul>
          <li>Threats of violence or harm</li>
          <li>Coordinated harassment campaigns</li>
          <li>Doxxing (sharing private information without consent)</li>
          <li>Stalking or intimidation</li>
          <li>Unwanted sexual content or advances</li>
        </ul>

        <h3>Misinformation</h3>
        <p>
          Deliberate campaigns to spread false information that could cause harm, including:
        </p>
        <ul>
          <li>Election fraud conspiracies designed to undermine democratic processes</li>
          <li>Medical misinformation that could lead to physical harm</li>
          <li>Coordinated inauthentic behavior</li>
          <li>Manipulated media presented as authentic</li>
        </ul>
        <p>
          <em>Note: Opinion, commentary, satire, and good-faith disagreement about facts are not misinformation.</em>
        </p>

        <h3>Violence and Harm</h3>
        <p>
          Content that glorifies, encourages, or provides instructions for:
        </p>
        <ul>
          <li>Violence against people or animals</li>
          <li>Self-harm or suicide</li>
          <li>Terrorism or extremist violence</li>
          <li>Child exploitation or abuse</li>
        </ul>

        <h3>Illegal Activity</h3>
        <p>
          Content that facilitates illegal activity, including:
        </p>
        <ul>
          <li>Sale of illegal goods or services</li>
          <li>Fraud or financial scams</li>
          <li>Copyright or trademark infringement</li>
        </ul>

        <h2>What's Allowed</h2>
        <p>
          We support a wide range of perspectives and encourage robust debate on important issues:
        </p>
        <ul>
          <li><strong>Political commentary</strong> across the spectrum, including criticism of governments, policies, and public figures</li>
          <li><strong>Religious discussion</strong>, including atheism, criticism of religious institutions, and interfaith dialogue</li>
          <li><strong>Scientific debate</strong> and discussion of controversial topics</li>
          <li><strong>Satire and humor</strong>, even when provocative</li>
          <li><strong>Reporting on sensitive topics</strong>, including violence, hate groups, and extremism (when done journalistically)</li>
          <li><strong>Advocacy</strong> for political causes and social movements</li>
        </ul>

        <h2>Moderation Process</h2>

        <h3>Reporting</h3>
        <p>
          Anyone can report content they believe violates this policy. Reports are reviewed by our moderation team.
        </p>

        <h3>Review</h3>
        <p>
          Our team reviews reported content within 48 hours. We consider:
        </p>
        <ul>
          <li>The content itself and its context</li>
          <li>The author's history on the platform</li>
          <li>Whether the content violates our policy</li>
          <li>The severity of the violation</li>
        </ul>

        <h3>Actions</h3>
        <p>
          Depending on the violation, we may:
        </p>
        <ul>
          <li><strong>Issue a warning</strong> to the author</li>
          <li><strong>Require content removal</strong> before the publication can continue</li>
          <li><strong>Suspend the publication</strong> temporarily</li>
          <li><strong>Permanently remove the publication</strong> from Beacon</li>
          <li><strong>Report to law enforcement</strong> when content involves illegal activity or imminent threats</li>
        </ul>

        <h3>Appeals</h3>
        <p>
          Authors can appeal moderation decisions. Appeals are reviewed by a different moderator within 5 business days.
        </p>

        <h2>Context Matters</h2>
        <p>
          We recognize that context is crucial. Journalism about hate groups is not the same as promoting hate. Academic discussion of controversial topics is not the same as endorsing harmful views. Our moderation team considers context, intent, and the overall nature of the content.
        </p>

        <h2>Transparency</h2>
        <p>
          We publish quarterly transparency reports showing:
        </p>
        <ul>
          <li>Number of reports received</li>
          <li>Number of content removals by category</li>
          <li>Number of appeals and outcomes</li>
          <li>Changes to our moderation policies</li>
        </ul>

        <h2>Questions?</h2>
        <p>
          If you have questions about this policy, email us at <a href="mailto:policy@beacon.pub">policy@beacon.pub</a>.
        </p>

        <hr>

        <p class="text-secondary">
          <small>
            Last updated: February 10, 2026<br>
            We may update this policy from time to time. Material changes will be announced to all users.
          </small>
        </p>
      </article>
    </div>
  </div>
</template>

<script setup lang="ts">
useHead({
  title: 'Content Policy - Beacon',
  meta: [
    {
      name: 'description',
      content: 'Beacon\'s content policy: Zero tolerance for hate speech, harassment, and misinformation. Clear moderation with appeals.'
    }
  ]
})
</script>

<style scoped>
.lead {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-8);
}

.prose ul {
  margin-bottom: var(--space-4);
}

.prose li {
  margin-bottom: var(--space-2);
}

.prose h3 {
  margin-top: var(--space-8);
  margin-bottom: var(--space-4);
  color: var(--color-text-primary);
}

.prose em {
  color: var(--color-text-secondary);
}

.prose hr {
  margin: var(--space-12) 0;
}
</style>
