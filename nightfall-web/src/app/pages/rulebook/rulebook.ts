import { Component, signal, computed, inject } from '@angular/core';
import { RULES_SECTIONS, RuleSection } from './rulebook.data';
import { LanguageService } from '../../shared/language/language.service';

@Component({
    selector: 'app-rulebook',
    standalone: true,
    templateUrl: './rulebook.html',
    styleUrl: './rulebook.css',
})
export class RulebookComponent {
    readonly ls = inject(LanguageService);
    sections = RULES_SECTIONS;
    currentPage = signal(0);

    totalPages = computed(() => this.sections.length);

    currentSection = computed(() => this.sections[this.currentPage()]);

    pageLabel = computed(
        () => `PAGE ${this.currentPage() + 1} OF ${this.totalPages()}`
    );

    canGoBack = computed(() => this.currentPage() > 0);
    canGoForward = computed(() => this.currentPage() < this.totalPages() - 1);

    nextPage(): void {
        if (this.canGoForward()) {
            this.currentPage.update((p) => p + 1);
        }
    }

    prevPage(): void {
        if (this.canGoBack()) {
            this.currentPage.update((p) => p - 1);
        }
    }

    goToPage(index: number): void {
        this.currentPage.set(index);
    }
}
