# Diagnostic Tool Analysis (DailyFixer)

This document explains how the diagnostic tool works across frontend (JSP/JS), backend (Java servlets + DAO + models), and database schema (`schema.sql`), and prepares you for a no-internet code-check focused on CRUD + business logic changes.

---

## 1) What the diagnostic tool is

The diagnostic tool is a **decision-tree based troubleshooting system**:
- Users browse published diagnostic guides by category.
- Users run a guide step-by-step (question → option → next node).
- Final result nodes allow users to submit ratings.
- Admins can create/edit/publish/delete trees and nodes.
- Volunteers (with enough reputation) can manage only their own trees/nodes.

---

## 2) Main architecture

## Frontend pages (JSP + JS)
- User browse:  
  `/src/main/webapp/pages/diagnostic/diagnostic-browse.jsp`
- User runner:  
  `/src/main/webapp/pages/diagnostic/diagnostic-runner.jsp`
- Admin list + builder:  
  `/src/main/webapp/pages/dashboards/admindash/diagnostic-trees.jsp`  
  `/src/main/webapp/pages/dashboards/admindash/diagnostic-tree-builder.jsp`
- Volunteer list + builder:  
  `/src/main/webapp/pages/dashboards/volunteerdash/diagnostic-trees.jsp`  
  `/src/main/webapp/pages/dashboards/volunteerdash/diagnostic-tree-builder.jsp`

## Backend API (Servlets)
- Trees (admin): `/api/diagnostic/trees`  
  `/src/main/java/com/dailyfixer/servlet/diagnostic/DiagnosticTreeServlet.java`
- Nodes (admin): `/api/diagnostic/nodes`  
  `/src/main/java/com/dailyfixer/servlet/diagnostic/DiagnosticNodeServlet.java`
- Categories: `/api/diagnostic/categories`  
  `/src/main/java/com/dailyfixer/servlet/diagnostic/DiagnosticCategoryServlet.java`
- Ratings: `/api/diagnostic/ratings`  
  `/src/main/java/com/dailyfixer/servlet/diagnostic/DiagnosticRatingServlet.java`
- Volunteer trees/nodes:  
  `/api/volunteer/diagnostic/trees`  
  `/api/volunteer/diagnostic/nodes`  
  in `VolunteerDiagnosticTreeServlet.java` and `VolunteerDiagnosticNodeServlet.java`

## Data access layer
- Trees DAO: `/src/main/java/com/dailyfixer/dao/DecisionTreeDAO.java`
- Nodes DAO: `/src/main/java/com/dailyfixer/dao/DecisionNodeDAO.java`
- Ratings DAO: `/src/main/java/com/dailyfixer/dao/TreeRatingDAO.java`
- Categories DAO used by category/tree flows:  
  `/src/main/java/com/dailyfixer/dao/CategoryDAO.java`

## Data models
- Tree: `/src/main/java/com/dailyfixer/model/DecisionTree.java`
- Node: `/src/main/java/com/dailyfixer/model/DecisionNode.java`
- Rating: `/src/main/java/com/dailyfixer/model/TreeRating.java`

## Database schema
- Active schema dump with diagnostic tables:  
  `/src/main/resources/schema.sql` (diagnostic tables around lines 346-433)
- Extra migration copy:  
  `/src/main/resources/migrations/old_extra_migrs/diagnostic_schema.sql`

---

## 3) End-to-end flow

## A. User browse flow
1. `diagnostic-browse.jsp` loads main categories (`GET /api/diagnostic/categories`).
2. User selects main category → loads subcategories (`GET ...?parent={id}`).
3. User selects subcategory → loads published trees (`GET /api/diagnostic/trees?category={id}`).
4. User can search trees (`GET /api/diagnostic/trees?search={text}`).
5. User opens runner page with `?id={treeId}`.

## B. User runner flow
1. `diagnostic-runner.jsp` calls:  
   `GET /api/diagnostic/trees/{treeId}?includeNodes=true`
2. Backend returns tree metadata + full hierarchical root node JSON.
3. JS shows current node; selecting options traverses in-memory tree.
4. On result node, rating UI appears.
5. Rating submit: `POST /api/diagnostic/ratings` with `treeId`, `rating`, optional `feedback`.

## C. Admin creation/edit flow
1. Builder page creates/updates tree via:
   - `POST /api/diagnostic/trees` (create)
   - `PUT /api/diagnostic/trees/{id}` (update metadata/status)
2. Builder creates/updates/deletes nodes via:
   - `POST /api/diagnostic/nodes`
   - `PUT /api/diagnostic/nodes/{id}`
   - `DELETE /api/diagnostic/nodes/{id}`
3. Publish toggle sends status-only PUT update.

## D. Volunteer flow
- Same UI behavior as admin, but APIs are volunteer scoped:
  - `/api/volunteer/diagnostic/trees`
  - `/api/volunteer/diagnostic/nodes`
- Backend enforces:
  - role = volunteer
  - reputation threshold via `ReputationUtils.isDiagnosticContributor(...)`
  - owner-only access to their own trees/nodes

---

## 4) Database design (important in code-check)

From `schema.sql`, core tables are:
- `diagnostic_categories` (self-parent hierarchy)
- `diagnostic_trees` (metadata, `status` draft/published)
- `diagnostic_nodes` (tree graph via `parent_id`, QUESTION/RESULT)
- `diagnostic_ratings` (1-5 rating, unique `(tree_id,user_id)`)

Important constraints/behavior:
- `diagnostic_nodes.parent_id` has **ON DELETE CASCADE** → deleting a node deletes descendants.
- `diagnostic_trees.tree_id` cascades to nodes + ratings.
- `diagnostic_trees.category_id` is **ON DELETE RESTRICT**.
- ratings have `CHECK (rating >= 1 AND rating <= 5)` + unique user-per-tree rating.

---

## 5) Complex pieces you should be ready to explain

1. **Tree reconstruction logic**  
   `DecisionNodeDAO.getTreeStructure(int treeId)`:
   - loads flat node list
   - builds node map by id
   - attaches children to parents
   - returns root node

2. **Status-only update optimization**  
   `DiagnosticTreeServlet.doPut(...)` uses a status-only path that calls `updateTreeStatus(...)` when only `status` is sent.

3. **PUT body parsing**  
   `parseRequestBody(...)` in tree/volunteer tree servlet parses URL-encoded body for PUT requests.

4. **Node root constraint**  
   `DiagnosticNodeServlet.doPost(...)` blocks creating a second root node using `nodeDAO.hasRootNode(treeId)`.

5. **Rating upsert**  
   `TreeRatingDAO.addOrUpdateRating(...)` uses:
   `INSERT ... ON DUPLICATE KEY UPDATE ...`  
   so one user can update their existing rating safely.

6. **Volunteer authorization + ownership**  
   Volunteer servlets validate role, reputation tier, then verify tree ownership before CRUD.

---

## 6) Likely code-check questions

1. Why does deleting a node remove children too?  
   (Explain DB FK cascade in `diagnostic_nodes.parent_id`.)

2. How does the app know a tree is runnable?  
   (Must have root node; runner fetches `includeNodes=true` and expects `rootNode`.)

3. Why can’t non-admin users call admin APIs?  
   (`isAdmin(session)` checks in admin servlets.)

4. How does volunteer access differ from admin access?  
   (Volunteer role + reputation + owner-only checks.)

5. Why can a user rate the same tree multiple times?  
   (Unique key + upsert updates previous rating.)

6. What happens if a category is deleted while trees exist?  
   (`ON DELETE RESTRICT` on `diagnostic_trees.category_id` prevents deletion.)

7. How is XSS handled in dynamic JS rendering?  
   (`escapeHtml(...)`/`escapeJs(...)` in JSP scripts and `escapeJson(...)` in servlets.)

---

## 7) Practical CRUD-style change requests they may ask

These are realistic “no-internet code-check” tasks:

### Example A: Add “archived” status for trees
**Likely ask:** “Add archived status and hide archived trees from browse.”

Steps:
1. DB: extend `diagnostic_trees.status` enum to include `archived`.
2. Backend:
   - allow archived in tree update validation.
   - ensure user browse/search/category queries only return published.
3. Frontend:
   - admin/volunteer dashboards can filter/show archived.
   - browse page remains published-only.

### Example B: Prevent publish if no root node
**Likely ask:** “Users should not publish empty trees.”

Steps:
1. In `DiagnosticTreeServlet.doPut` (and volunteer equivalent), before setting `published`, check `nodeDAO.hasRootNode(treeId)`.
2. Return `400` with clear error when root missing.
3. In builder JS, show error toast/alert from API response.

### Example C: Edit node option ordering
**Likely ask:** “Allow custom option order for child nodes.”

Steps:
1. Use existing `display_order` field.
2. Backend already supports updating `displayOrder` in node PUT.
3. Add simple reorder UI (up/down buttons), call `PUT /api/.../nodes/{id}` with new order.
4. Reload tree to verify order.

### Example D: Add category rename feature
**Likely ask:** “Allow admin to rename a diagnostic category.”

Steps:
1. Add `PUT /api/diagnostic/categories/{id}` in `DiagnosticCategoryServlet`.
2. Validate duplicate name with `CategoryDAO.categoryExists(...)`.
3. Keep category ids unchanged so trees stay linked.

### Example E: Show average rating in admin/volunteer builder header
**Likely ask:** “Display live average rating when editing a published tree.”

Steps:
1. Frontend builder page calls `GET /api/diagnostic/ratings?tree={id}`.
2. Render `averageRating` and `ratingCount`.
3. If draft tree has no ratings, show 0 safely.

---

## 8) How to approach these changes safely in code-check

1. Start from API contract first:
   - confirm request params used by current JS (`URLSearchParams` form format).
2. Keep authorization checks intact:
   - admin vs volunteer ownership logic.
3. Respect DB constraints:
   - cascades/restrict behavior can cause surprises.
4. Update both equivalent flows:
   - admin servlet + volunteer servlet when behavior should match.
5. Re-test core flows quickly:
   - create tree
   - add root node + child nodes
   - publish/unpublish
   - run guide
   - submit/update rating

---

## 9) Fast mental model for explanation

- **Tree = metadata** (`diagnostic_trees`)  
- **Nodes = decision graph** (`diagnostic_nodes`)  
- **Categories = taxonomy** (`diagnostic_categories`)  
- **Ratings = user feedback** (`diagnostic_ratings`)  

Frontend loads categories/trees, backend serves JSON manually, DAO maps rows to models, and schema FK rules enforce lifecycle behavior.

If asked to change behavior, locate:
1) schema constraint  
2) DAO query  
3) servlet validation  
4) JSP fetch/render logic

This 4-layer check keeps changes correct and minimal.

