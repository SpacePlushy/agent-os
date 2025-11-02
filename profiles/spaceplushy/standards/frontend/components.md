## UI component best practices

### Component Design Principles

- **Single Responsibility**: Each component should have one clear purpose and do it well
- **Reusability**: Design components to be reused across different contexts with configurable props
- **Composability**: Build complex UIs by combining smaller, simpler components rather than monolithic structures
- **Clear Interface**: Define explicit, well-documented props with sensible defaults for ease of use
- **Encapsulation**: Keep internal implementation details private and expose only necessary APIs
- **Consistent Naming**: Use clear, descriptive names that indicate the component's purpose and follow team conventions

### React/Next.js Specific

- **Server Components by Default**: In Next.js App Router, components are Server Components unless marked with `'use client'`
- **Client Components When Needed**: Only use `'use client'` for:
  - Interactive elements requiring event handlers
  - Components using React hooks (useState, useEffect, useContext)
  - Components accessing browser APIs
- **Component Composition**: Pass Server Components as children to Client Components for optimal performance
- **TypeScript Props**: Always define prop types with TypeScript interfaces
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
  onClick?: () => void
  children: React.ReactNode
}
```

### State Management

- **Local State First**: Keep state as local as possible; lift up only when needed by multiple components
- **Server State**: Use Server Components to fetch and pass data; minimize client-side state
- **URL State**: Store filter/pagination state in URL params for shareability
- **Form State**: Use controlled components for forms; consider react-hook-form for complex forms
- **Global State**: Use React Context sparingly; consider Zustand or Jotai for complex global state
- **Server Actions**: Use Server Actions for form submissions in Next.js; avoid client-side API calls

### Props Management

- **Minimal Props**: Keep the number of props manageable; if a component needs many props, consider composition or splitting it
- **Default Props**: Provide sensible defaults for optional props
- **Prop Drilling**: Avoid deep prop drilling; use composition, Context, or state management library
- **Destructuring**: Destructure props in function signature for clarity
```typescript
function Button({ variant = 'primary', size = 'md', children, ...props }: ButtonProps) {
  return <button className={cn(styles[variant], styles[size])} {...props}>{children}</button>
}
```
- **Rest Props**: Spread remaining props (`...props`) to underlying HTML elements for flexibility
- **Children Prop**: Use `children` prop for composability; prefer over render props unless needed

### Component Organization

- **File Structure**: One component per file; name file after component (Button.tsx)
- **Colocation**: Keep related files together (component, styles, tests, types)
```
components/
  Button/
    Button.tsx
    Button.test.tsx
    Button.module.css
    index.ts
```
- **Barrel Exports**: Use index.ts files to re-export components for cleaner imports
- **Component Categories**: Organize into folders: ui/, layout/, features/, pages/

### Naming Conventions

- **Component Names**: PascalCase, descriptive and specific (UserProfileCard not Card)
- **File Names**: Match component name (UserProfileCard.tsx)
- **Props Interface**: ComponentNameProps (ButtonProps, CardProps)
- **Handler Props**: Prefix with 'on' (onClick, onSubmit, onValueChange)
- **Boolean Props**: Prefix with 'is', 'has', 'should' (isLoading, hasError, shouldShow)

### Performance Optimization

- **Memoization**: Use React.memo for expensive components that re-render often with same props
- **useMemo**: Memoize expensive calculations
- **useCallback**: Memoize callback functions passed to child components
- **Code Splitting**: Lazy load heavy components with next/dynamic
```typescript
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <p>Loading...</p>,
  ssr: false // Client-side only if needed
})
```
- **Image Optimization**: Always use next/image; specify sizes prop appropriately
- **Bundle Size**: Monitor component bundle size; avoid large dependencies

### Styling

- **Tailwind CSS**: Preferred styling solution; use utility classes
- **cn() Helper**: Use cn() utility (from clsx + tailwind-merge) for conditional classes
```typescript
import { cn } from '@/lib/utils'

className={cn(
  'base-classes',
  variant === 'primary' && 'primary-classes',
  disabled && 'disabled-classes'
)}
```
- **CSS Modules**: Alternative for component-scoped styles; import as `styles`
- **Avoid Inline Styles**: Use Tailwind or CSS Modules; inline styles only for dynamic values
- **Consistent Spacing**: Use Tailwind spacing scale (p-4, m-2, etc.)
- **Dark Mode**: Support dark mode with `dark:` variant classes

### Accessibility

- **Semantic HTML**: Use semantic elements (button, nav, article, etc.) not just divs
- **ARIA Labels**: Add aria-label for icon buttons and screen reader context
- **Keyboard Navigation**: Ensure all interactive elements are keyboard accessible
- **Focus Management**: Visible focus indicators; manage focus in modals/dialogs
- **Alt Text**: Provide descriptive alt text for images
- **Color Contrast**: Ensure sufficient color contrast (WCAG AA minimum)
- **Form Labels**: Associate labels with form inputs using htmlFor

### Error Boundaries

- **Error Handling**: Use Error Boundaries (error.tsx in Next.js) to catch rendering errors
- **Graceful Degradation**: Show user-friendly error messages; don't crash entire app
- **Error Reporting**: Log errors to monitoring service (Sentry)
- **Retry Mechanisms**: Provide retry button for recoverable errors

### Component Documentation

- **JSDoc Comments**: Document component purpose, props, and usage
```typescript
/**
 * Primary button component for user actions
 * @param variant - Visual style variant (primary, secondary, ghost)
 * @param size - Size of the button (sm, md, lg)
 * @param children - Button label or content
 */
export function Button({ variant, size, children }: ButtonProps) {
  // ...
}
```
- **Storybook**: Create stories for component variations and states
- **Usage Examples**: Provide code examples in README or comments
- **Prop Descriptions**: Document each prop's purpose and accepted values

### Testing

- **Unit Tests**: Test component logic and rendering with React Testing Library
- **User Interactions**: Test with user-centric queries (getByRole, getByLabelText)
- **Accessibility Tests**: Use jest-axe for automated accessibility testing
- **Visual Regression**: Consider Chromatic or Percy for visual regression testing
- **Coverage**: Aim for 80%+ coverage of component logic

### Common Patterns

#### Compound Components
```typescript
// Card component with subcomponents
export const Card = ({ children }: { children: React.ReactNode }) => (
  <div className="card">{children}</div>
)

Card.Header = ({ children }: { children: React.ReactNode }) => (
  <div className="card-header">{children}</div>
)

Card.Body = ({ children }: { children: React.ReactNode }) => (
  <div className="card-body">{children}</div>
)

// Usage
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
</Card>
```

#### Polymorphic Components
```typescript
type AsProps<T extends React.ElementType> = {
  as?: T
} & React.ComponentPropsWithoutRef<T>

function Text<T extends React.ElementType = 'span'>({
  as,
  ...props
}: AsProps<T>) {
  const Component = as || 'span'
  return <Component {...props} />
}

// Usage: <Text as="h1">Heading</Text>
```

### Anti-Patterns to Avoid

- **Prop Drilling**: Don't pass props through many layers; use composition or Context
- **Huge Components**: Split components over 200 lines; extract logic and subcomponents
- **Inline Functions**: Don't define functions inside JSX; use useCallback or define outside
- **Mutating Props**: Props are immutable; never modify props directly
- **Index as Key**: Don't use array index as key in lists; use stable unique IDs
- **Too Many useEffects**: Excessive useEffects indicate design issues; refactor to Server Components when possible
- **Premature Abstraction**: Don't abstract until you see a pattern repeated 2-3 times

### shadcn/ui Integration

- **Component Library**: Use shadcn/ui for common UI components (Button, Input, Dialog, etc.)
- **Copy, Don't Import**: shadcn/ui copies components to your project; you own the code
- **Customization**: Customize components to match design system; they're just starting points
- **Tailwind Config**: Ensure shadcn/ui theme tokens are in tailwind.config.js
- **Radix Primitives**: shadcn/ui built on Radix UI; inherits accessibility features
