import React from 'react';
import { css } from '@emotion/css';
import { COLORS } from '../common/theme';
import { ContentTemplate, ContentFooter } from '../components';

const styles = {
    container: css`
        display: flex;
        justify-content: center;
        align-items: center;
    `,
    main: css`
        width: 600px;
        margin: 30px 16px 30px;
    `,
    titleSection: css`
        margin-bottom: 60px;  
    `,
    section: css`
        margin-bottom: 40px;
    `,
    desc: css`
        margin: 0 0 0 2px;
    `,
    contentFooter: css`
        margin: 0 auto 40px;
    `
}

const Policy = () => {
    return (
        <ContentTemplate>
            <div className={styles.container}>
                <div className={styles.main}>
                    <section className={styles.titleSection}>
                        <h2>プライバシーポリシー</h2>
                        <div className={styles.desc}>
                            <p>本サービスにおける、ユーザーの個人情報の取扱いについて、以下の通りプライバシーポリシーを定めます。</p>
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h3>個人情報の収集・利用について</h3>
                        <div className={styles.desc}>
                            <p>匿名で個人を特定できない範囲で情報の収集を行っています。</p>
                            <p>それらはサービスの提供・運営のために利用されます。</p>
                            <p>また、アクティブなデバイス数やアプリクラッシュ時の情報等を収集し、アプリの利便性向上や不具合の解消に利用されます。</p>
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h3>個人情報の第三者提供について</h3>
                        <div className={styles.desc}>
                            <p>ユーザーの同意を得ることなく、第三者に個人情報を提供することはありません。</p>
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h3>免責事項</h3>
                        <div className={styles.desc}>
                            <p>利用者が本アプリを利用して生じた損害に関して、開発元は一切の責任を負わないものとします。</p>
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h3>著作権・知的財産権等</h3>
                        <div className={styles.desc}>
                            <p>著作権その他一切の権利は、当方又は権利を有する第三者に帰属します。</p>
                        </div>
                    </section>
                </div>
            </div>
            
            <ContentFooter className={styles.contentFooter} firstLink={'introduction'} secondLink={'contact'} />
        </ContentTemplate>
    )
};

export default Policy;