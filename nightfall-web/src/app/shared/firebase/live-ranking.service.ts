import { Injectable, signal, computed } from '@angular/core';
import { ref, onValue, off, DatabaseReference, DataSnapshot } from 'firebase/database';
import { db } from './firebase.config';

export interface PlayerAnalytics {
  roleId: number;
  roleName: string;
  allianceId: number;
  winningTeam: string;
  won: boolean;
  pointsEarned: number;
  playedAt: string;
}

export interface RankedPlayer {
  id: string;
  name: string;
  points: number;
  analytics: PlayerAnalytics[];
  previousRank?: number;
}

const STORAGE_KEY = 'nf_live_code';

@Injectable({ providedIn: 'root' })
export class LiveRankingService {
  private _players = signal<RankedPlayer[]>([]);
  private _sessionCode = signal<string | null>(localStorage.getItem(STORAGE_KEY));
  private _connected = signal(false);
  private _error = signal<string | null>(null);
  private _previousRanks = new Map<string, number>();
  private _listenerRef: DatabaseReference | null = null;

  readonly players = this._players.asReadonly();
  readonly sessionCode = this._sessionCode.asReadonly();
  readonly connected = this._connected.asReadonly();
  readonly error = this._error.asReadonly();

  readonly hasSession = computed(() => this._sessionCode() !== null);

  constructor() {
    const saved = this._sessionCode();
    if (saved) {
      this._subscribe(saved);
    }
  }

  connect(code: string): void {
    const normalized = code.trim().toUpperCase();
    if (normalized.length !== 6) {
      this._error.set('Code must be 6 characters');
      return;
    }
    this._disconnect();
    this._sessionCode.set(normalized);
    localStorage.setItem(STORAGE_KEY, normalized);
    this._error.set(null);
    this._subscribe(normalized);
  }

  disconnect(): void {
    this._disconnect();
    this._sessionCode.set(null);
    this._connected.set(false);
    this._players.set([]);
    this._previousRanks.clear();
    localStorage.removeItem(STORAGE_KEY);
  }

  private _subscribe(code: string): void {
    this._listenerRef = ref(db, `sessions/${code}/players`);
    onValue(
      this._listenerRef,
      (snapshot: DataSnapshot) => {
        this._connected.set(true);
        this._error.set(null);
        if (!snapshot.exists()) {
          this._players.set([]);
          return;
        }
        const data = snapshot.val() as Record<string, any>;
        const currentPlayers = this._players();

        const currentRanks = new Map<string, number>();
        currentPlayers.forEach((p, i) => currentRanks.set(p.id, i + 1));

        const players: RankedPlayer[] = Object.entries(data)
          .map(([id, val]) => ({
            id,
            name: val.name ?? id,
            points: val.points ?? 0,
            analytics: Array.isArray(val.analytics)
              ? (val.analytics as PlayerAnalytics[])
              : [],
            previousRank: currentRanks.get(id),
          }))
          .sort((a, b) => b.points - a.points);

        this._players.set(players);
      },
      (err: Error) => {
        this._error.set('Session not found or connection lost');
        this._connected.set(false);
      },
    );
  }

  private _disconnect(): void {
    if (this._listenerRef) {
      off(this._listenerRef);
      this._listenerRef = null;
    }
  }
}
