# RespiLink Backend

This is the Laravel backend for the RespiLink App.

## Events & Webinars Module

The system includes a robust Events and Webinars module.
Admins can create events using the admin endpoints, which go through a state machine before doctors can see them.

### State Diagram

```text
       [ Create Event ]
              |
              v
          ( DRAFT )  <-----------------------+
              |                              |
      submitForReview()                      |
              |                              |
              v                              |
         ( REVIEW )                          |
              |                              |
          publish()                      unpublish()
              |                              |
              v                              |
        ( PUBLISHED ) -----------------------+
```
*(Only DRAFT, REVIEW, and UNPUBLISHED events can be edited. PUBLISHED events are locked from edits until they are unpublished.)*

### New Doctor Endpoints
- `GET /api/v1/events` (Published events only, paginated, searchable, filterable)
- `GET /api/v1/events/{event}` (Published event details)
- `GET /api/v1/events/mine` (My registrations)
- `POST /api/v1/events/{event}/register` (Register for event)
- `DELETE /api/v1/events/{event}/register` (Cancel registration)

### New Admin Endpoints
- `GET /api/admin/v1/events` (All events, paginated, filterable)
- `POST /api/admin/v1/events` (Create draft event)
- `GET /api/admin/v1/events/{event}` (View event details)
- `PUT /api/admin/v1/events/{event}` (Edit event - draft/review only)
- `DELETE /api/admin/v1/events/{event}` (Soft delete event)
- `POST /api/admin/v1/events/{event}/submit-for-review`
- `POST /api/admin/v1/events/{event}/publish`
- `POST /api/admin/v1/events/{event}/unpublish`
- `GET /api/admin/v1/events/{event}/registrations` (List event registrations)

## Interactive Quizzes & Leaderboard Module

The system includes a fully featured interactive quizzes and leaderboard module to boost engagement.

### Quiz Flow

1. Admin creates a draft quiz and adds questions with multiple choices.
2. Admin submits for review, then publishes the quiz.
3. Doctors (verified only) can start the quiz, answer questions one by one, and submit.
4. Badges are awarded automatically (e.g. `first_quiz`, `perfect_score`, `streak_5`).
5. A scheduled task `quiz:finalize` runs hourly to close expired quizzes and award `top_3` badges to the podium finishers.

### Quiz Endpoints (Doctor API)
- `GET /api/v1/quizzes`
- `GET /api/v1/quizzes/{quiz}`
- `POST /api/v1/quizzes/{quiz}/start`
- `POST /api/v1/quizzes/{quiz}/answer`
- `POST /api/v1/quizzes/{quiz}/submit`
- `GET /api/v1/quizzes/{quiz}/leaderboard`
- `GET /api/v1/quizzes/{quiz}/result`
- `GET /api/v1/badges/mine`

### Quiz Endpoints (Admin API)
- `GET /api/admin/v1/quizzes`
- `POST /api/admin/v1/quizzes`
- `GET /api/admin/v1/quizzes/{quiz}`
- `PUT /api/admin/v1/quizzes/{quiz}`
- `DELETE /api/admin/v1/quizzes/{quiz}`
- `POST /api/admin/v1/quizzes/{quiz}/questions`
- `PUT /api/admin/v1/quizzes/{quiz}/questions/{question}`
- `DELETE /api/admin/v1/quizzes/{quiz}/questions/{question}`
- `POST /api/admin/v1/quizzes/{quiz}/submit-for-review`
- `POST /api/admin/v1/quizzes/{quiz}/publish`
- `GET /api/admin/v1/quizzes/{quiz}/leaderboard`
- `POST /api/admin/v1/quizzes/{quiz}/leaderboard/recalculate`