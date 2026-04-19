import React from "react";
import { UserCircle2, BookOpen, Newspaper, Plus } from "lucide-react";
import styles from "./BottomNav.module.css";

const BottomNav = () => {
  return (
    <footer className={styles.footer}>
      <button className={styles.navItem} type="button">
        <div className={styles.profileWrap}>
          <UserCircle2 size={27} />
          <span className={styles.greenPlus}>
            <Plus size={16} />
          </span>
        </div>
      </button>

      <button className={`${styles.navItem} ${styles.active}`} type="button">
        <BookOpen size={29} />
      </button>

      <button className={styles.navItem} type="button">
        <Newspaper size={27} />
      </button>
    </footer>
  );
};

export default BottomNav;