import { Component, signal, inject } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { StarfieldComponent } from '../shared/starfield/starfield';
import { LangSwitchComponent } from '../shared/lang-switch/lang-switch.component';
import { LanguageService } from '../shared/language/language.service';

@Component({
    selector: 'app-layout',
    standalone: true,
    imports: [RouterOutlet, RouterLink, RouterLinkActive, StarfieldComponent, LangSwitchComponent],
    templateUrl: './layout.html',
    styleUrl: './layout.css',
})
export class LayoutComponent {
    readonly ls = inject(LanguageService);
    menuOpen = signal(false);

    toggleMenu(): void {
        this.menuOpen.update((v) => !v);
    }

    closeMenu(): void {
        this.menuOpen.set(false);
    }
}
