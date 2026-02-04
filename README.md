# CI/CD Pipeline Implementation

## 📌 Overview
This repository focuses on the **design and implementation of a CI/CD pipeline** for an existing application.  
The goal of this project is to demonstrate **continuous integration and delivery practices**, automation, and quality assurance, rather than application feature development.

The application code itself was already provided; my contribution is centered on the **CI/CD infrastructure and workflows**.

---

## 🎯 Objectives
- Automate build, test, and verification stages
- Enforce code quality and testing standards
- Build and publish containerized artifacts
- Automate deployment and basic runtime validation
- Provide traceability and reproducibility across environments

---

## 🛠️ CI/CD Pipeline Features

### Continuous Integration
- Automated build using **Maven**
- Separation of build and test stages for faster feedback
- Execution of:
  - Unit tests
  - Integration tests
- Code coverage reporting with **JaCoCo**
- Static code analysis with **SonarQube**
- Mutation testing using **PIT** to assess test effectiveness
- Consumer-driven contract testing with **Pact**

---

### Continuous Delivery
- Automated Docker image build
- Deterministic image tagging strategy (environment + build number)
- Automatic image publishing to a container registry
- Fully automated deployment for selected services
- Manual approval gates for controlled rollouts (when applicable)

---

### Deployment & Runtime Validation
- Deployment using **Docker** and **Docker Compose / Swarm**
- Health checks to validate service availability
- Smoke and lightweight load tests executed post-deployment
- Support for rollback through image versioning

---

## 🧱 Technologies & Tools
- **CI/CD**: Jenkins
- **Build & Dependency Management**: Maven
- **Testing**: JUnit, PIT, Pact
- **Code Quality**: SonarQube, JaCoCo
- **Containerization**: Docker, Docker Compose / Docker Swarm
- **Load Testing**: k6
- **Reverse Proxy / Traffic Management**: Caddy
