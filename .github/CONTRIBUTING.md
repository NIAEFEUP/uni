# Contributing to uni

First off, thank you for considering contributing to **uni**! 

**uni** is primarily developed and maintained by **[NIAEFEUP](https://niaefeup.pt/)**. However, we believe that the best tools are built by the community, and outside contributions are always welcome!

### Important: University Account Required
Please note that to contribute effectively and explore all of the app's features (such as schedules, grades, and private student data), **you must have a valid University of Porto (Sigarra) account**. Most of the app's core functionality relies on authenticated requests to university systems.

---

## Documentation & Guides

To keep our documentation fresh and accessible, our technical guides are at the **[Project Wiki](https://github.com/niaefeup/uni/wiki)**. Please consult the wiki before starting your development journey.

### Getting Started
* **New to the project?** Start with the **[Development Setup](https://github.com/niaefeup/uni/wiki/Development-Setup)** guide.
* **Need to run the app?** Check out **[Running the App](https://github.com/niaefeup/uni/wiki/Running-the-App)**.
* **Want to understand the code?** Read the **[Architecture Overview](https://github.com/niaefeup/uni/wiki/Architecture-Overview)**.

---

## Contribution Workflow

1.  **Find an Issue**: Browse our [open issues](https://github.com/niaefeup/uni/issues). If you have a new idea, open an issue first to discuss it with the team.
2.  **Fork & Branch**: Create a feature branch from `develop` using our [Conventional Branching](https://github.com/niaefeup/uni/wiki/Branching-&-Commits) rules (e.g., `feat/add-new-widget`).
3.  **Code & Lint**: Write your code and ensure it passes our linting checks. We use a [pre-commit hook](https://github.com/niaefeup/uni/wiki/Code-Formatting-&-Linting) to maintain code quality.
4.  **Submit a Pull Request**: Open a PR against the `develop` branch. Ensure you fill out the PR template provided.

### Pull Request Checklist
- [ ] I have synced my branch with the latest `develop`.
- [ ] My code follows the project's [linting and formatting](https://github.com/niaefeup/uni/wiki/Code-Formatting-&-Linting) rules.
- [ ] I have run [build_runner](https://github.com/niaefeup/uni/wiki/Code-Generation) if I modified any database entities or providers.
- [ ] I have tested the changes an emulator or device.

---

## Reporting Bugs

If you find a bug, please [open an issue](https://github.com/niaefeup/uni/issues/new). High-quality bug reports with reproduction steps and screenshots are greatly appreciated!

## Community & Support

Need help?
* Reach out via our [socials](https://linktr.ee/niaefeup) or our [website](https://niaefeup.pt).