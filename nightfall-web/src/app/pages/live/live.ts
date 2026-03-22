import {
  Component,
  inject,
  signal,
  AfterViewInit,
  AfterViewChecked,
  ElementRef,
  ViewChild,
  ViewChildren,
  QueryList,
  Injector,
  afterNextRender,
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LanguageService } from '../../shared/language/language.service';
import {
  LiveRankingService,
  RankedPlayer,
} from '../../shared/firebase/live-ranking.service';

interface RoleStats {
  roleId: number;
  roleName: string;
  played: number;
  won: number;
}

// Maps Flutter roleId → local image path
const ROLE_IMAGES: Record<number, string> = {
  1:  'images/werewolves/Villager.png',
  2:  'images/werewolves/Werewolf.png',
  3:  'images/werewolves/Doctor.png',
  4:  'images/werewolves/Guard.png',
  5:  'images/werewolves/Plague Doctor.png',
  6:  'images/werewolves/Twins.png',
  7:  'images/werewolves/Avenging Twin.png',
  8:  'images/werewolves/Vampire.png',
  9:  'images/werewolves/Jester.png',
  10: 'images/werewolves/Drunk.png',
  11: 'images/werewolves/Knight.png',
  12: 'images/werewolves/Puppet Master.png',
  13: 'images/werewolves/Executioner.png',
  14: 'images/werewolves/Infected.png',
  15: 'images/werewolves/Gambler.png',
  16: 'images/werewolves/Shaman.png',
  17: 'images/werewolves/Wraith.png',
  18: 'images/werewolves/Dire Wolf.png',
};

@Component({
  selector: 'app-live',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './live.html',
  styleUrl: './live.css',
})
export class LiveComponent implements AfterViewInit, AfterViewChecked {
  @ViewChild('codeField') codeFieldRef?: ElementRef<HTMLInputElement>;
  @ViewChildren('playerRow') playerRows!: QueryList<ElementRef<HTMLElement>>;

  private readonly injector = inject(Injector);
  readonly ls = inject(LanguageService);
  readonly ranking = inject(LiveRankingService);

  codeInput = signal('');
  expandedPlayer = signal<string | null>(null);

  // FLIP animation state
  private _prevTops = new Map<string, number>();
  private _lastOrder: string[] = [];
  private _animating = false;

  ngAfterViewInit(): void {
    this.codeFieldRef?.nativeElement.focus();
  }

  ngAfterViewChecked(): void {
    if (!this.playerRows || this.playerRows.length === 0) return;

    const currentOrder = this.players().map((p) => p.id);
    const orderChanged =
      currentOrder.join('|') !== this._lastOrder.join('|') &&
      this._lastOrder.length > 0;

    if (orderChanged && !this._animating) {
      this._flip();
    }

    if (!this._animating) {
      this._storeTops();
      this._lastOrder = [...currentOrder];
    }
  }

  private _storeTops(): void {
    this._prevTops.clear();
    this.playerRows.forEach((ref) => {
      const id = ref.nativeElement.dataset['id'];
      if (id) {
        this._prevTops.set(id, ref.nativeElement.getBoundingClientRect().top);
      }
    });
  }

  private _flip(): void {
    const movers: { el: HTMLElement; delta: number }[] = [];

    this.playerRows.forEach((ref) => {
      const el = ref.nativeElement;
      const id = el.dataset['id'];
      if (!id) return;
      const prevTop = this._prevTops.get(id);
      if (prevTop === undefined) return;
      const newTop = el.getBoundingClientRect().top;
      const delta = prevTop - newTop;
      if (Math.abs(delta) > 1) movers.push({ el, delta });
    });

    if (movers.length === 0) return;

    this._animating = true;

    // Invert: snap elements back to where they were
    movers.forEach(({ el, delta }) => {
      el.style.transition = 'none';
      el.style.transform = `translateY(${delta}px)`;
    });

    // Force reflow so the browser registers the transform before we transition
    movers[0].el.offsetHeight;

    // Play: animate to natural (new) position
    movers.forEach(({ el }) => {
      el.style.transition = 'transform 0.55s cubic-bezier(0.34, 1.2, 0.64, 1)';
      el.style.transform = 'translateY(0)';
    });

    setTimeout(() => {
      movers.forEach(({ el }) => {
        el.style.transition = '';
        el.style.transform = '';
      });
      this._animating = false;
      this._storeTops();
      this._lastOrder = this.players().map((p) => p.id);
    }, 600);
  }

  readonly players = this.ranking.players;
  readonly connected = this.ranking.connected;
  readonly hasSession = this.ranking.hasSession;
  readonly sessionCode = this.ranking.sessionCode;
  readonly error = this.ranking.error;

  onCodeInput(value: string): void {
    const cleaned = value.toUpperCase().replace(/[^A-Z]/g, '').slice(0, 6);
    this.codeInput.set(cleaned);
    if (cleaned.length === 6) {
      this.ranking.connect(cleaned);
    }
  }

  connect(): void {
    const code = this.codeInput();
    if (code.length === 6) {
      this.ranking.connect(code);
    }
  }

  disconnect(): void {
    this.ranking.disconnect();
    this.codeInput.set('');
    this.expandedPlayer.set(null);
    // Input is re-created when session ends — focus after view updates
    afterNextRender(
      () => {
        const el = this.codeFieldRef?.nativeElement;
        el?.focus();
        el?.select();
      },
      { injector: this.injector },
    );
  }

  togglePlayer(id: string): void {
    this.expandedPlayer.update((c) => (c === id ? null : id));
  }

  isExpanded(id: string): boolean {
    return this.expandedPlayer() === id;
  }

  getRankColor(rank: number): string {
    if (rank === 1) return '#FFD700';
    if (rank === 2) return '#C0C0C0';
    if (rank === 3) return '#CD7F32';
    return '#E0E1DD';
  }

  getRankChange(player: RankedPlayer, currentRank: number): string {
    if (player.previousRank === undefined) return '';
    if (player.previousRank < currentRank) return 'down';
    if (player.previousRank > currentRank) return 'up';
    return '';
  }

  getTotalGames(player: RankedPlayer): number {
    return player.analytics.length;
  }

  getTotalWins(player: RankedPlayer): number {
    return player.analytics.filter((a) => a.won).length;
  }

  getWinRate(player: RankedPlayer): string {
    const total = this.getTotalGames(player);
    if (total === 0) return '0';
    return ((this.getTotalWins(player) / total) * 100).toFixed(0);
  }

  getAllianceGames(player: RankedPlayer, allianceId: number): number {
    return player.analytics.filter((a) => a.allianceId === allianceId).length;
  }

  getAllianceWins(player: RankedPlayer, allianceId: number): number {
    return player.analytics.filter(
      (a) => a.allianceId === allianceId && a.won,
    ).length;
  }

  getAlliancePct(player: RankedPlayer, allianceId: number): number {
    const games = this.getAllianceGames(player, allianceId);
    if (games === 0) return 0;
    return Math.round(
      (this.getAllianceWins(player, allianceId) / games) * 100,
    );
  }

  getAllianceColor(allianceId: number): string {
    if (allianceId === 1) return '#52B788';
    if (allianceId === 2) return '#E63946';
    if (allianceId === 3) return '#9D4EDD';
    return '#E0E1DD';
  }

  getRoleStats(player: RankedPlayer): RoleStats[] {
    const map = new Map<number, RoleStats>();
    for (const a of player.analytics) {
      if (!map.has(a.roleId)) {
        map.set(a.roleId, {
          roleId: a.roleId,
          roleName: a.roleName,
          played: 0,
          won: 0,
        });
      }
      const s = map.get(a.roleId)!;
      s.played++;
      if (a.won) s.won++;
    }
    return [...map.values()].sort((a, b) => b.played - a.played);
  }

  getRolePct(s: RoleStats): number {
    if (s.played === 0) return 0;
    return Math.round((s.won / s.played) * 100);
  }

  getRoleImage(roleId: number): string {
    return ROLE_IMAGES[roleId] ?? '';
  }

  getRoleColor(roleId: number): string {
    const colors: Record<number, string> = {
      1: '#E0E1DD',
      2: '#E63946',
      3: '#4CAF50',
      4: '#FFD166',
      5: '#06D6A0',
      6: '#4CC9F0',
      7: '#E63946',
      8: '#E63946',
      9: '#9D4EDD',
      10: '#CD9777',
      11: '#9E2A2B',
      12: '#7209B7',
      13: '#6B4226',
      14: '#8E9B97',
      15: '#D4AF37',
      16: '#E8720C',
      17: '#6EC6CA',
      18: '#E63946',
    };
    return colors[roleId] ?? '#E0E1DD';
  }
}
