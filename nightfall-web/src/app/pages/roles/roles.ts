import { Component, signal, computed, inject } from '@angular/core';
import { ROLES, ALLIANCES, Role, Alliance } from './roles.data';
import { LanguageService } from '../../shared/language/language.service';

@Component({
    selector: 'app-roles',
    standalone: true,
    templateUrl: './roles.html',
    styleUrl: './roles.css',
})
export class RolesComponent {
    readonly ls = inject(LanguageService);
    alliances = ALLIANCES;
    expandedRole = signal<string | null>(null);

    villageRoles = computed(() =>
        ROLES.filter((r) => r.alliance === 'village')
    );
    werewolvesRoles = computed(() =>
        ROLES.filter((r) => r.alliance === 'werewolves')
    );
    specialsRoles = computed(() =>
        ROLES.filter((r) => r.alliance === 'specials')
    );

    getRolesForAlliance(alliance: Alliance): Role[] {
        return ROLES.filter((r) => r.alliance === alliance.id);
    }

    toggleRole(id: string): void {
        this.expandedRole.update((current) => (current === id ? null : id));
    }

    isExpanded(id: string): boolean {
        return this.expandedRole() === id;
    }

    getAllianceClass(id: string): string {
        return `alliance-${id}`;
    }

    getPointsNoteLines(key: string): string[] {
        const text = this.ls.t(key as any);
        return text.split(',').map(s => s.trim());
    }
}
