import { Routes } from '@angular/router';
import { LayoutComponent } from './layout/layout';

export const routes: Routes = [
    {
        path: '',
        component: LayoutComponent,
        children: [
            { path: '', redirectTo: 'roles', pathMatch: 'full' },
            {
                path: 'roles',
                loadComponent: () =>
                    import('./pages/roles/roles').then((m) => m.RolesComponent),
            },
            {
                path: 'rulebook',
                loadComponent: () =>
                    import('./pages/rulebook/rulebook').then((m) => m.RulebookComponent),
            },
        ],
    },
];
