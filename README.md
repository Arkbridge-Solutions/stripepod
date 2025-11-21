# Serverpod 3.0 + Stripe Payment Sheet Starter 🚀

**The "Vertical Slice" Boilerplate for robust Flutter payments.**

*Maintained by [Arkbridge Solutions](https://arkbridge.co.uk)*

---

## ⚡ The Opportunity
When Serverpod came out it was a game changer for Flutter developers because now we could build full-stack applications with a single language (Dart). It is now possible to integrate payments in backend and frontend (on 3 different platforms: Web, Android and iOS) in a single codebase and in just a few hours.


## ✅ The Solution

This repository is a clean, vertical slice of a production payment flow. It uses:

- **Serverpod 3.0 (RC)**: Leveraging the latest backend architecture
- **Stripe Payment Sheet**: Native UI for Card, Apple Pay, and Google Pay
- **Secure Webhooks**: Verifying signatures and handling idempotency
- **Database Logging**: Storing payment status in Postgres (not in memory)

## 🏗 Architecture

We follow the **"Verify, Don't Trust"** principle. The App handles the UI, but the Server handles the logic.

1. **App**: Requests a PaymentIntent from Serverpod backend
2. **Server**: Creates an Intent and logs a pending record in the database
3. **App**: Displays the native Stripe Payment Sheet (mobile) or PaymentElement (web)
4. **Stripe**: Charges the card and fires a webhook to Serverpod
5. **Server**: Validates the webhook signature and updates the database record to `succeeded`

## 🛠 Prerequisites

- **Flutter SDK** (Latest Stable)
- **Serverpod** (Version 3.0+) see [serverpod docs](https://docs.serverpod.dev/next/)
- **Docker Desktop** (Running)
- **Stripe Account & Stripe CLI** (For local webhook testing) [See stripe docs](https://stripe.com/docs/stripe-cli)

## 🚀 Quick Start (Integration in < 10 Mins)

### 1. Infrastructure Setup

Navigate to the server directory and start the infrastructure.

```bash
cd stripepod_server
docker compose up --build --detach
```

### 2. Configuration

Duplicate the password template and fill in your secrets.

```bash
cp config/passwords.yaml.example config/passwords.yaml
```

**Edit `passwords.yaml`**: Add your Database password and Stripe Secret Key (`sk_test_...`).

### 3. Stripe CLI (Crucial)

To receive webhooks locally, you must tunnel them to your localhost.

**Login**: 
```bash
stripe login
```

**Start listening** and forward to your Serverpod endpoint:

```bash
stripe listen --forward-to http://localhost:8082/webhook
```

Copy the **Signing Secret** (`whsec_...`) output by the CLI and add it to your `passwords.yaml` or environment config.

### 4. Run the Server

Apply the database migrations (creates the `payment_log` table) and start the server.

```bash
dart bin/main.dart --apply-migrations
```

### 5. Run the App

Launch the Flutter client.

```bash
cd stripepod_flutter
flutter run
```

## 🧐 Pragmatic Notes (Why we built it this way)

### 1. The Database Log vs. In-Memory

You will notice we generate a table `payments` and write to it immediately when an intent is created.

> **Tip**: Never rely on in-memory state for payments. If your server restarts during a transaction, the record is lost. Always write to disk (DB).

### 2. The "Hardcoded" Frontend

The product catalog is hardcoded in the Flutter UI.

> **Tip**: We did this to keep the boilerplate dependency-free. In a real app, you would fetch this from the DB, but for this starter kit, we prioritized readability over complexity.

### 3. Zero Frontend Dependencies

We used `StatefulWidget` and `ValueNotifier` instead of Bloc/Riverpod.

> **Tip**: Dependencies are debt. This boilerplate is designed to be copy-pasted into any architecture without conflicting with your existing state management.

---

## 🤝 Need to Scale?

This boilerplate handles the **"First Transaction."** Scaling to subscriptions, handling proration, and automating DevOps (Terraform/K8s) requires a deeper strategy.

**Arkbridge Solutions** specializes in Dart Full-Stack & Flutter.

- 🔗 [Connect with Remon Helmond on LinkedIn](https://linkedin.com)
- 🌐 [Visit arkbridge.co.uk](https://arkbridge.co.uk)

---

**Disclaimer**: This code is provided "as is" for educational purposes. Always perform a security audit before deploying financial code to production.