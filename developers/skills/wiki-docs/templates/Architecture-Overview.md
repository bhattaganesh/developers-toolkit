# Architecture Overview

> High-level architecture and design decisions for {project_name}.

## System Overview

{system_overview}

<!-- 2-3 paragraphs covering: -->
<!-- - Overall architectural style (monolith, microservices, serverless, etc.) -->
<!-- - Key design principles the project follows -->
<!-- - How the major pieces fit together -->

## Architecture Diagram

```
{ascii_architecture_diagram}
```

<!-- Draw an ASCII diagram showing major components and their connections -->
<!-- Example: Client -> API Gateway -> Controllers -> Services -> Database -->

## Core Components

### {component_name}
- **Purpose:** {component_purpose}
- **Location:** `{component_directory_path}/`
- **Key files:** {component_key_files}
- **Depends on:** {component_dependencies}

<!-- Repeat this block for each major component discovered in the project -->
<!-- Typically 3-8 components depending on project size -->

{additional_components}

## Data Flow

### {data_flow_name}
<!-- Describe the most important data flow in the application -->
<!-- Use step-by-step format showing how data moves through components -->

{data_flow_steps}

### {secondary_data_flow_name}
<!-- Describe a second key data flow -->

{secondary_data_flow_steps}

## Technology Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| {decision_area} | {technology_chosen} | {rationale} |

<!-- Document key technology choices and why they were made -->
<!-- Common areas: framework, database, cache, queue, auth, testing -->

## Directory Structure

```
{project_root}/
├── {directory_1}/          # {directory_1_purpose}
├── {directory_2}/          # {directory_2_purpose}
├── {directory_3}/          # {directory_3_purpose}
├── {directory_4}/          # {directory_4_purpose}
└── {root_config_files}     # {config_files_purpose}
```

<!-- Show the top-level directory layout with brief descriptions -->
<!-- Include only the most important directories, not every folder -->

## Security Architecture

{security_overview}

<!-- Cover the following areas as applicable: -->
<!-- - Authentication method (session, token, OAuth, nonce, etc.) -->
<!-- - Authorization approach (roles, permissions, policies, capabilities) -->
<!-- - Input validation strategy -->
<!-- - Data protection (encryption, hashing, sanitization) -->

## Related Pages

- [Database Schema](Database-Schema) — Data model and relationships
- [Environment Configuration](Environment-Configuration) — Runtime configuration
- [{stack_specific_page}]({stack_specific_page_link}) — {stack_specific_page_description}

---

*See also: [Database Schema](Database-Schema) | [Getting Started](Getting-Started)*
